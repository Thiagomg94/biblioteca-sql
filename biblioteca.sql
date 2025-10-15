-- Projeto: Sistema de Biblioteca
-- Autor: Thiago de Oliveira Santos
-- Banco: MySQL
-- Descrição: Estrutura básica de banco de dados para controle de livros e empréstimos.

-- 1 Criação do bando de dados
create database if not exists biblioteca;
use biblioteca;

-- 2 Criação das tabelas
CREATE TABLE autores (
    id_autor INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE livros (
    id_livro INTEGER PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    id_autor INTEGER,
    ano_publicacao INTEGER,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE emprestimos (
    id_emprestimo INTEGER PRIMARY KEY,
    id_livro INTEGER,
    id_usuario INTEGER,
    data_emprestimo DATE,
    data_devolucao DATE,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- 3 Inserção dos dados
INSERT INTO autores VALUES
(1, 'Machado de Assis'),
(2, 'Clarice Lispector'),
(3, 'J. K. Rowling');

INSERT INTO livros VALUES
(1, 'Dom Casmurro', 1, 1899),
(2, 'A Hora da Estrela', 2, 1977),
(3, 'Harry Potter e a Pedra Filosofal', 3, 1997);

INSERT INTO usuarios VALUES
(1, 'João Silva', 'joao@email.com'),
(2, 'Maria Souza', 'maria@email.com');

INSERT INTO emprestimos VALUES
(1, 1, 1, '2025-10-01', NULL),
(2, 3, 2, '2025-09-28', '2025-10-10');

-- 4 Consultas uteis

-- a) Livros atualmente emprestados
SELECT l.titulo, u.nome AS usuario, e.data_emprestimo
FROM emprestimos e
JOIN livros l ON e.id_livro = l.id_livro
JOIN usuarios u ON e.id_usuario = u.id_usuario
WHERE e.data_devolucao IS NULL;

-- b) Quantidade de empréstimos por usuário
SELECT u.nome, COUNT(e.id_emprestimo) AS total_emprestimos
FROM usuarios u
LEFT JOIN emprestimos e ON u.id_usuario = e.id_usuario
GROUP BY u.nome;

-- c) Livros disponíveis para empréstimo
SELECT titulo
FROM livros
WHERE id_livro NOT IN (
    SELECT id_livro FROM emprestimos WHERE data_devolucao IS NULL
);