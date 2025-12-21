CREATE DATABASE db_trabalho3B;
USE db_trabalho3B;

CREATE TABLE Autores (
    ID_autor INT AUTO_INCREMENT PRIMARY KEY,
    Nome_autor VARCHAR(255) NOT NULL,
    Nacionalidade VARCHAR(255),
    Data_nascimento DATE,
    Biografia TEXT
);

CREATE TABLE Generos (
    ID_genero INT AUTO_INCREMENT PRIMARY KEY,
    Nome_genero VARCHAR(255) NOT NULL
);

CREATE TABLE Editoras (
    ID_editora INT AUTO_INCREMENT PRIMARY KEY,
    Nome_editora VARCHAR(255) NOT NULL,
    Endereco_editora TEXT
);

CREATE TABLE Livros (
    ID_livro INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL,
    Autor_id INT,
    ISBN VARCHAR(13) NOT NULL,
    Ano_publicacao INT,
    Genero_id INT,
    Editora_id INT,
    Quantidade_disponivel INT,
    Resumo TEXT,
    FOREIGN KEY (Autor_id) REFERENCES Autores(ID_autor),
    FOREIGN KEY (Genero_id) REFERENCES Generos(ID_genero),
    FOREIGN KEY (Editora_id) REFERENCES Editoras(ID_editora)
);

CREATE TABLE Usuarios (
    ID_usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nome_usuario VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Numero_telefone VARCHAR(15),
    Data_inscricao DATE,
    Multa_atual DECIMAL(10, 2)
);

CREATE TABLE Emprestimos (
    ID_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    Usuario_id INT,
    Livro_id INT,
    Data_emprestimo DATE,
    Data_devolucao_prevista DATE,
    Data_devolucao_real DATE,
    Status_emprestimo ENUM('pendente', 'devolvido', 'atrasado'),
    FOREIGN KEY (Usuario_id) REFERENCES Usuarios(ID_usuario),
    FOREIGN KEY (Livro_id) REFERENCES Livros(ID_livro)
);

#tabela feita para registrar automaticamente todas as alterações importantes feitas no banco de dados
CREATE TABLE log_base (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabela_alterada VARCHAR(50),
    procedimento VARCHAR(10),
    data_hora DATETIME,
    dados_antigos TEXT,
    dados_novos TEXT
);

-- Exemplo 01 --
#Essa trigger é responsável por registrar os autores cadastrados
delimiter //
create trigger log_adicionar_autores after insert on Autores for each row 
begin 
	insert into log_base (
		tabela_alterada ,
		procedimento ,
		data_hora ,
		dados_antigos ,
		dados_novos 
	)
	values ( 
		'autores',
		'insert',
		now(),
		null,
		concat('Nome: ', new.Nome_autor,
			', Nacionalidade: ', new.Nacionalidade, 
			', Data_nascimento: ', new.Data_nascimento, 
			', Biografia: ', new.Biografia
            )
	);
end //
delimiter ;

-- Exemplo 02 --
#Essa trigger é responsável por registrar os livros cadastrados
delimiter //
create trigger log_adicionar_livro after insert on Livros for each row 
begin 
	insert into log_base (
		tabela_alterada ,
		procedimento ,
		data_hora ,
		dados_antigos ,
		dados_novos 
	)
	values ( 
		'livros',
		'insert',
		now(),
		null,
		concat('Titulo: ', new.Titulo,
			', Autor: ', new.Autor_id, 
			', ISBN: ', new.ISBN, 
			', Ano de publicacao: ', new.Ano_publicacao,
            ', Gênero: ', new.Genero_id,
            ', Editora: ', new.Editora_id,
            ', Quantidade: ', new.Quantidade_disponivel,
            ', Resumo: ', new.Resumo
            )
	);
end //
delimiter ;

-- Exemplo 03 --
#Essa trigger é responsável por registrar quais os livros foram excluídos
delimiter //
create trigger log_excluir_livro after insert on Livros for each row 
begin 
	insert into log_base (
		tabela_alterada ,
		procedimento ,
		data_hora ,
		dados_antigos ,
		dados_novos 
	)
	values ( 
		'livros',
		'delete',
		now(),
		null,
		concat('Titulo: ', old.Titulo,
			', Autor: ', old.Autor_id, 
			', ISBN: ', old.ISBN, 
			', Ano de publicacao: ', old.Ano_publicacao,
            ', Gênero: ', old.Genero_id,
            ', Editora: ', old.Editora_id,
            ', Quantidade: ', old.Quantidade_disponivel,
            ', Resumo: ', old.Resumo
            )
	);
end //
delimiter ;

-- Exemplo 04 --
#Essa trigger é responsável por registrar quais os usuários foram excluídos
delimiter //
create trigger log_excluir_usuario after delete on Usuarios for each row 
begin 
	insert into log_base (
		tabela_alterada ,
		procedimento ,
		data_hora ,
		dados_antigos ,
		dados_novos 
	)
	values ( 
		'usuario',
		'delete',
		now(),
		concat('Nome do Usuário: ', old.Nome_usuario, 
			', Email: ', old.Email, 
			', Telefone: ', old.Numero_telefone,
            ', Data de Inscrição: ', old.Data_inscricao,
            ', Multa atual: ', old.Multa_atual
		),
		null
	);
end //
delimiter ;

-- Exemplo 05 --
#Essa trigger é responsável por registrar a atualização feita na quantidade de livros disponíveis
delimiter //
create trigger log_atualizar_quantidade after update on Livros for each row
begin
    insert into log_base (
        tabela_alterada,
        procedimento,
        data_hora,
        dados_antigos,
        dados_novos
    )
    values (
        'Livros',
        'update',
        now(),
        concat(
            'Quantidade Inicial: ', old.Quantidade_disponivel
        ),
        concat(
            'Quantidade Nova: ', new.Quantidade_disponivel
        )
    );
end//
delimiter ;