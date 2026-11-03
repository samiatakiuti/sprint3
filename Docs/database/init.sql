CREATE SEQUENCE seq_matricula_aluno
START WITH 1
INCREMENT BY 1;-- ============================================================-- FUNÇÃO PARA GERAÇÃO DA MATRÍCULA-- ============================================================-- A função gera automaticamente uma matrícula no formato:-- AL000001-- AL000002-- AL000003
CREATE OR REPLACE FUNCTION gerar_matricula_aluno()
RETURNS VARCHAR
AS $$
BEGIN
RETURN
'AL' ||
LPAD(
nextval('seq_matricula_aluno')::TEXT,
6,
'0'
);
END;
$$ LANGUAGE plpgsql;-- ============================================================-- TABELA ALUNO-- ============================================================

CREATE TABLE aluno (
id_aluno INTEGER GENERATED ALWAYS AS IDENTITY,-- A matrícula será gerada automaticamente-- caso não seja informada no INSERT.
matricula VARCHAR(20) UNIQUE
NOT NULL
DEFAULT gerar_matricula_aluno(),
nome VARCHAR(150) NOT NULL,
data_nascimento DATE NOT NULL,
email VARCHAR(150) NOT NULL,
telefone VARCHAR(20) NOT NULL,
CONSTRAINT pk_aluno
PRIMARY KEY (id_aluno),
CONSTRAINT uq_aluno_matricula
UNIQUE (matricula)
);
-- ============================================================-- TABELA LIVRO-- ============================================================
CREATE TABLE livro (
id_livro INTEGER GENERATED ALWAYS AS IDENTITY,
titulo VARCHAR(200) NOT NULL,
autor VARCHAR(150) NOT NULL,
editora VARCHAR(150) NOT NULL,
ano_publicacao INTEGER NOT NULL,
isbn VARCHAR(20) NOT NULL UNIQUE,
quantidade_total INTEGER NOT NULL CHECK (quantidade_total > 0),
quantidade_disponivel INTEGER NOT NULL CHECK (
quantidade_disponivel >= 0
AND quantidade_disponivel <= quantidade_total
),
CONSTRAINT pk_livro
PRIMARY KEY (id_livro),
CONSTRAINT uq_livro_isbn
UNIQUE (isbn),
CONSTRAINT ck_livro_quantidade_total
CHECK (quantidade_total > 0),
CONSTRAINT ck_livro_quantidade_disponivel
CHECK (
quantidade_disponivel >= 0
AND quantidade_disponivel <= quantidade_total
)
);
-- ============================================================-- TABELA EMPRESTIMO-- ============================================================
CREATE TABLE emprestimo (
id_emprestimo INTEGER GENERATED ALWAYS AS IDENTITY,
id_aluno INTEGER NOT NULL,
data_emprestimo DATE NOT NULL DEFAULT CURRENT_DATE,
data_prevista_devolucao DATE NOT NULL CHECK (
data_prevista_devolucao >= data_emprestimo
),
data_devolucao DATE CHECK (
data_devolucao IS NULL
OR data_devolucao >= data_emprestimo
),
CONSTRAINT pk_emprestimo
PRIMARY KEY (id_emprestimo),
CONSTRAINT fk_emprestimo_aluno
FOREIGN KEY (id_aluno)
REFERENCES aluno (id_aluno),
CONSTRAINT ck_emprestimo_data_prevista
CHECK (
data_prevista_devolucao >= data_emprestimo
),
CONSTRAINT ck_emprestimo_data_devolucao
CHECK (
data_devolucao IS NULL
OR data_devolucao >= data_emprestimo
)
);

INSERT INTO aluno ( nome, data_nascimento, email, telefone)
VALUES
('Jon Snow', '2008-02-14', 'jon.snow@email.com', '16990000001'),
('Arya Stark', '2009-04-22', 'arya.stark@email.com', '16990000002'),
('Tyrion Lannister', '2007-11-18', 'tyrion.lannister@email.com', '16990000003'),
('Daenerys Targaryen', '2008-07-01', 'daenerys.targaryen@email.com', '16990000004'),
('Arthur Morgan', '2007-03-09', 'arthur.morgan@email.com', '16990000005'), 
('John Marston', '2008-09-16', 'john.marston@email.com', '16990000006'),
('Sadie Adler', '2009-01-27', 'sadie.adler@email.com', '16990000007'),
('Dutch van der Linde', '2007-06-12', 'dutch.vanderlinde@email.com', '16990000008');

INSERT INTO livro ( titulo, autor, editora, ano_publicacao, isbn, quantidade_total,
quantidade_disponivel)
VALUES
( 'Introdução à Orientação a Objetos com C++ e Python', 'Orlando Saraiva Jr.','Novatec', 2017, '978-85-7522-548-6', 12, 12),
('Análise e Design Orientados a Objetos', 'Hélio Engholm Jr.', 'Novatec', 2013,'978-85-7522-340-6', 10, 10 ),
('C# - Guia de Consulta Rápida','Joel Saade','Novatec', 2008, '978-85-7522-146-4',14, 14),
('Requisitos em Projetos de Software e de Sistemas de Informação', 'João M. Fernandes e Ricar
do J. Machado', 'Novatec', 2017, '978-85-7522-566-0', 11, 11),
('Engenharia de Software na Prática', 'Hélio Engholm Jr.', 'Novatec', 2010,'978-85-7522-2171', 13, 13),
('Fundamentos da Engenharia de Software','Nathaniel Schutta e Dan Vega','Novatec',2026,'978-85-7522-982-8', 15, 15),
('Harry Potter e a Pedra Filosofal', 'J. K. Rowling', 'Rocco', 2000, '978-85-325-1101-0', 15, 15),
('Harry Potter e a Câmara Secreta', 'J. K. Rowling', 'Rocco', 2000, '978-85-325-1166-9',12, 12),
('Harry Potter e o Prisioneiro de Azkaban', 'J. K. Rowling', 'Rocco', 2000, '978-85-325-12062', 14, 14),
('Harry Potter e o Cálice de Fogo','J. K. Rowling','Rocco', 2001,'978-85-325-1252-9',11, 11),
('Harry Potter e a Ordem da Fênix', 'J. K. Rowling', 'Rocco', 2003, '978-85-325-1622-0',15, 15),
('Harry Potter e o Enigma do Príncipe', 'J. K. Rowling', 'Rocco', 2005, '978-85-325-1947-4', 13, 13),
('Harry Potter e as Relíquias da Morte','J. K. Rowling','Rocco', 2007, '978-85-325-2261-0', 12, 12),
('O Senhor dos Anéis: A Sociedade do Anel', 'J. R. R. Tolkien', 'HarperCollins', 2019,'978-85-9508-475-9', 15, 15),
('O Senhor dos Anéis: As Duas Torres','J. R. R. Tolkien', 'HarperCollins', 2019, '978-85-9508-476-6', 13, 13),
('O Senhor dos Anéis: O Retorno do Rei','J. R. R. Tolkien','HarperCollins',2019,'978-85-9508477-3', 12, 12),
('A Guerra dos Tronos','George R. R. Martin','Suma',2019,'978-85-5651-078-5', 14, 14),
('A Fúria dos Reis','George R. R. Martin','Suma', 2019,'978-85-5651-079-2', 10, 10),
('A Tormenta de Espadas', 'George R. R. Martin', 'Suma', 2019, '978-85-5651-080-8', 13,13),
('O Festim dos Corvos','George R. R. Martin', 'Suma', 2019,'978-85-5651-088-4', 11,1);

INSERT INTO emprestimo ( id_aluno, data_prevista_devolucao )
VALUES
( 1, CURRENT_DATE + 7),
( 2, CURRENT_DATE + 7),
( 3, CURRENT_DATE + 7),
( 4, CURRENT_DATE + 7),
( 5, CURRENT_DATE + 7);

INSERT INTO item_emprestimo ( id_emprestimo, id_livro)
VALUES-- Empréstimo 1 - Jon Snow
(1, 1),(1, 7),(1, 14),-- Empréstimo 2 - Arya Stark
(2, 2),(2, 8),(2, 15),-- Empréstimo 3 - Tyrion Lannister
(3, 3),(3, 9),(3, 16),-- Empréstimo 4 - Daenerys Targaryen
(4, 4),(4, 10),(4, 17),-- Empréstimo 5 - Arthur Morgan
(5, 5),(5, 11),(5, 18);
