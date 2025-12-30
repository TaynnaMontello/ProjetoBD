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
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598

#tabela feita para registrar automaticamente todas as alterações importantes feitas no banco de dados
CREATE TABLE log_base (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabela_alterada VARCHAR(50),
    procedimento VARCHAR(10),
    data_hora DATETIME,
    dados_antigos TEXT,
    dados_novos TEXT
);

<<<<<<< HEAD
CREATE TABLE log_acesso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    ip_origem VARCHAR(45),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

# ---- GATILHOS DE VALIDAÇÃO ---- (Mickeias)
 
-- Questão 01 --
delimiter //
create trigger bloquear_insercao_autor_existente
before insert on Autores
for each row
begin
    declare existe int;
   
    select count(*) into existe from Autores
    where lower(trim(Nome_autor)) = lower(trim(new.Nome_autor));

    if existe > 0 then
        signal sqlstate '45000'
        set message_text = "Autor já existe no banco de dados!";
    end if;
end //
delimiter ;

-- Questão 02 -- 
delimiter //
create trigger bloquear_update_autor_duplicado
before update on Autores
for each row
begin
    declare existe int;

    select count(*) into existe from Autores
    where lower(trim(Nome_autor)) = lower(trim(new.Nome_autor))
      and ID_autor <> old.ID_autor;

    if existe > 0 then
        signal sqlstate '45000'
        set message_text = 'Autor já existe no banco de dados!';
    end if;
end //
delimiter ;

-- Questão 03 -- 
delimiter //
create trigger ano_publicacao_invalido 
before insert on Livros
for each row
begin
    if new.Ano_publicacao < 1500 or 
       new.Ano_publicacao > year(curdate()) then
       signal sqlstate '45000'
       set message_text = 'O ano de publicação não está coerente.';
	end if;
end //
delimiter ;

-- Questão 04 --
delimiter //
create trigger emprestimo_quantidade_livro
before insert on Emprestimos
for each row
begin
    declare qtd_livros int;
   
    select Quantidade_disponivel into qtd_livros from Livros 
    where ID_livro = new.Livro_id;
    
    
    if qtd_livros <= 0 then
        signal sqlstate '45000'
        set message_text = 'Não existe livros disponíveis para você fazer empréstimo.';
    end if;
end //
delimiter ;

-- Questão 05 --
delimiter //
create trigger permissao_emprestimo_multa
before insert on Emprestimos
for each row
begin
    declare multa decimal(10, 2);
   
    select Multa_atual into multa from Usuarios 
    where ID_usuario = new.Usuario_id;
    
    if multa > 0 then
        signal sqlstate '45000'
        set message_text = 'Não pode fazer emprestimos com multa pendente.';
    end if;
end //
delimiter ;


# ---- GATILHOS DE AUDITORIA ---- (Taynná)
=======
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598
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

<<<<<<< HEAD

-- Exemplo 03 --
#Essa trigger é responsável por registrar quais os livros foram excluídos
delimiter //
create trigger log_excluir_livros after delete on Livros for each row 
=======
-- Exemplo 03 --
#Essa trigger é responsável por registrar quais os livros foram excluídos
delimiter //
create trigger log_excluir_livro after delete on Livros for each row 
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598
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
<<<<<<< HEAD
=======
		null,
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598
		concat('Titulo: ', old.Titulo,
			', Autor: ', old.Autor_id, 
			', ISBN: ', old.ISBN, 
			', Ano de publicacao: ', old.Ano_publicacao,
            ', Gênero: ', old.Genero_id,
            ', Editora: ', old.Editora_id,
            ', Quantidade: ', old.Quantidade_disponivel,
            ', Resumo: ', old.Resumo
<<<<<<< HEAD
            ),
		null
	);
end//
=======
            )
	);
end //
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598
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
<<<<<<< HEAD


# ---- GATILHOS DE ATUALIZAÇÃO AUTOMÁTICA PÓS-EVENTO ---- (Felipe)
-- 1.  Alterar a situação do “aluno” para inativo quando todos os empréstimos forem finalizados.
DELIMITER //
CREATE TRIGGER trg_usuario_inativo
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Emprestimos
        WHERE Usuario_id = NEW.Usuario_id
        AND Status_emprestimo = 'pendente'
    ) THEN
        UPDATE Usuarios
        SET Multa_atual = 0
        WHERE ID_usuario = NEW.Usuario_id;
    END IF;
END//
DELIMITER ;

-- 2. Ajustar automaticamente a quantidade disponível do livro quando um empréstimo é realizado.
DELIMITER //
CREATE TRIGGER trg_emprestimo_insert
AFTER INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    UPDATE Livros
    SET Quantidade_disponivel = Quantidade_disponivel - 1
    WHERE ID_livro = NEW.Livro_id;
END//
DELIMITER ;

-- 3. Atualizar automaticamente a quantidade disponível do livro quando um empréstimo é devolvido.
DELIMITER //
CREATE TRIGGER trg_emprestimo_devolucao
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF OLD.Status_emprestimo <> 'devolvido'
       AND NEW.Status_emprestimo = 'devolvido' THEN
        UPDATE Livros
        SET Quantidade_disponivel = Quantidade_disponivel + 1
        WHERE ID_livro = NEW.Livro_id;
    END IF;
END//

DELIMITER ;

-- 4. Gerar automaticamente uma multa ao usuário quando o empréstimo passa para o status “atrasado”.
DELIMITER //
CREATE TRIGGER trg_emprestimo_atraso
AFTER UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF OLD.Status_emprestimo <> 'atrasado'
       AND NEW.Status_emprestimo = 'atrasado' THEN
        UPDATE Usuarios
        SET Multa_atual = IFNULL(Multa_atual, 0) + 5.00
        WHERE ID_usuario = NEW.Usuario_id;
    END IF;
END//

DELIMITER ;

-- 5. Corrigir automaticamente o estoque e os dados do usuário quando um empréstimo é cancelado.
DELIMITER //
CREATE TRIGGER trg_cancelamento_emprestimo
AFTER DELETE ON Emprestimos
FOR EACH ROW
BEGIN
    UPDATE Livros
    SET Quantidade_disponivel = Quantidade_disponivel + 1
    WHERE ID_livro = OLD.Livro_id;

    UPDATE Usuarios
    SET Multa_atual = 0
    WHERE ID_usuario = OLD.Usuario_id;
END//

DELIMITER ;


# ---- GATILHOS DE VALORES ---- (Abraão)
-- Gatilho 01 --
#Essa trigger preenche automaticamente a data de inscrição quando não informada
delimiter //
create trigger preencher_data_inscricao before insert on Usuarios for each row
begin
    if new.Data_inscricao is null then
        set new.Data_inscricao = curdate();
    end if;
end //
delimiter ;

-- Gatilho 02 --
#Essa trigger define um valor padrão de multa (zero) caso não seja informado
delimiter //
create trigger definir_multa_padrao before insert on Usuarios for each row
begin
    if new.Multa_atual is null then
        set new.Multa_atual = 0.00;
    end if;
end //
delimiter ;

-- Gatilho 03 --
#Essa trigger define quantidade padrão e gera resumo automático do livro
delimiter //
create trigger definir_quantidade_e_resumo before insert on Livros for each row
begin
    if new.Quantidade_disponivel is null then
        set new.Quantidade_disponivel = 1;
    end if;
    
    if new.Resumo is null or new.Resumo = '' then
        set new.Resumo = concat(
            'Livro: ', new.Titulo, 
            '. Ano: ', ifnull(new.Ano_publicacao, 'Não informado'), 
            '. Cadastrado em ', date_format(now(), '%d/%m/%Y'), '.'
        );
    end if;
end //
delimiter ;

-- Gatilho 04 --
#Essa trigger calcula automaticamente a data de devolução prevista (15 dias)
delimiter //
create trigger calcular_data_devolucao before insert on Emprestimos for each row
begin
    if new.Data_emprestimo is null then
        set new.Data_emprestimo = curdate();
    end if;
    
    if new.Data_devolucao_prevista is null then
        set new.Data_devolucao_prevista = date_add(new.Data_emprestimo, interval 15 day);
    end if;
end //
delimiter ;

-- Gatilho 05 --
#Essa trigger define status padrão como 'pendente' quando não informado
delimiter //
create trigger definir_status_padrao before insert on Emprestimos for each row
begin
    if new.Status_emprestimo is null then
        set new.Status_emprestimo = 'pendente';
    end if;
end //
delimiter ;
=======
=======
>>>>>>> 172737842f51ef5e789d02a8545622a5a963638a
>>>>>>> 2f4031082d8eebd43bf435fcf7edd99583648598
