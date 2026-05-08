-- 1. Criação do Banco de Dados
CREATE DATABASE CineVerseDB;
GO

USE CineVerseDB;
GO

-- 2. Criação da Tabela Franquias
CREATE TABLE Franquias (
    franquiaId INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) UNIQUE
);
GO

-- 3. Criação da Tabela Atores
CREATE TABLE Atores (
    atorId INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) UNIQUE
);
GO

-- 4. Criação da Tabela Personagens
CREATE TABLE Personagens (
    personagemId INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(MAX),
    tipoMidia VARCHAR(20),
    franquiaId INT NOT NULL,
    atorId INT,

    -- Regra de Negócio Crítica: Evita o mesmo personagem na mesma franquia
    CONSTRAINT UK_Personagem_Franquia UNIQUE (nome, franquiaId),

    -- Chaves Estrangeiras
    CONSTRAINT FK_Personagens_Franquias 
        FOREIGN KEY (franquiaId) REFERENCES Franquias(franquiaId),

    CONSTRAINT FK_Personagens_Atores 
        FOREIGN KEY (atorId) REFERENCES Atores(atorId)
);
GO