-- Estrutura do banco de dados do TCC
-- ModernCuts
# --------------------------------------------------------------------------------------------------------------------------------------------

create database moderncuts_db;
use moderncuts_db;

# --------------------------------------------------------------------------------------------------------------------------------------------    
-- Estrutura base do banco:

create table cidade (
cidade_id smallint (5) primary key not null auto_increment, 
cidade varchar(50) NOT NULL,
uf enum ("AC","AL","AP","AM","BA","CE","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO","DF") 
);

create table endereco (
endereco_id smallint primary key not null auto_increment,
logradouro varchar(80) not null,
numero_casa int not null,
complemento varchar (80),
bairro varchar(20) not null,
cidade_id smallint(5) not null,
cep varchar(10) not null,

constraint fk_endereco_cidade foreign key(cidade_id) references cidade (cidade_id)
on update cascade on delete cascade
);

create table login (
login_id int primary key not null auto_increment,
usuario varchar (30) unique not null,
senha varchar (30) not null,
ativo tinyint(1) not null default '1'
);

create table cliente (
cliente_id int primary key not null auto_increment,
cpf bigint unique not null,
nome varchar (50) not null,
sobrenome varchar (100) not null,
data_nasc date not null,
genero varchar (50) not null,
endereco_id smallint not null,
email varchar (200) not null,
ativo tinyint(1) not null default '1',
num_telefone varchar (20) not null,
login_id int,

constraint fk_cliente_endereco foreign key(endereco_id) references endereco (endereco_id)
on update cascade on delete cascade,
constraint fk_cliente_login foreign key(login_id) references login (login_id)
on update cascade on delete cascade
);

create table funcionario (
funcionario_id int primary key not null auto_increment,
cpf bigint unique not null,
nome varchar (50) not null,
sobrenome varchar (100) not null,
data_nasc date not null,
genero varchar (50) not null,
endereco_id smallint not null,
email varchar (200) not null,
gerente tinyint(1) not null default '0',
ativo tinyint(1) not null default '1',
login_id int,

constraint fk_funcionario_endereco foreign key (endereco_id) references endereco (endereco_id)
on update cascade on delete cascade,
constraint fk_funcionario_login foreign key (login_id) references login (login_id)
on update cascade on delete cascade
);

create table servicos (
servico_id int primary key not null auto_increment,
nome_servico varchar (50) not null,
valor_servico decimal (5,2) not null
);

create table agendamento (
agendamento_id int primary key not null auto_increment,
servico_id int,
cliente_id int not null,
funcionario_id int not null,
data_horario datetime,
observacoes varchar (200),

constraint fk_agendamento_servicos foreign key (servico_id) references servicos (servico_id)
on update cascade on delete cascade,
constraint fk_agendamento_cliente foreign key (cliente_id) references cliente (cliente_id)
on update cascade on delete cascade,
constraint fk_agendamento_funcionario foreign key (funcionario_id) references funcionario (funcionario_id)
on update cascade on delete cascade
);

create table servicos_agendamento (
servico_id int not null,
agendamento_id int not null,

constraint fk_servicos_agendamento_servicos foreign key(servico_id) references servicos (servico_id)
on update cascade on delete cascade,
constraint fk_servicos_agendamento_agendamento foreign key(agendamento_id) references agendamento (agendamento_id)
on update cascade on delete cascade
);

create table categoria (	
categoria_id int primary key not null auto_increment,
tipo_categoria varchar(255)
);

create table produtos (
produto_id int primary key not null auto_increment,
categoria_id int,
descricao_produto varchar (255),
estoque smallint (5), 
preco decimal (5,2),

constraint fk_produtos_categoria foreign key (categoria_id) references categoria (categoria_id)
);

create table pedido (
pedido_id int primary key not null auto_increment,
produto_id int,
cliente_id int,
data_pedido datetime,
valor_produto decimal (5,2),
qtde smallint (5),
valor_total decimal (5,2),

constraint fk_pedido_cliente foreign key (cliente_id) references cliente (cliente_id),
constraint fk_pedido_produto foreign key (produto_id) references produtos (produto_id)
);

create table pagamento (
pagamento_id int primary key not null auto_increment,
cliente_id int,
funcionario_id int,
pedido_id int,
valor decimal (5,2),
data_pagamento datetime,

constraint fk_pagamento_cliente foreign key (cliente_id) references cliente (cliente_id),
constraint fk_pagamento_funcionario foreign key (funcionario_id) references funcionario (funcionario_id),
constraint fk_pagamento_pedido foreign key (pedido_id) references pedido (pedido_id)
);

# --------------------------------------------------------------------------------------------------------------------------------------------    
-- Inserts:

insert into cidade (cidade, uf) values 
	('Natal', 'RN'), 
	('Bahia Formosa', 'RN'), 
	('Lagoa de Pedras', 'RN');
    
insert into endereco (logradouro, numero_casa, complemento, bairro, cidade_id, cep) values 
	("Antônio Basílio", 285, "A", "Bom Pastor", "1", 59052000),
	("João Batista de Mendonça", 3, "Nenhum", "Centro", "2", 59194-000),
	("José Oliveira", 9, "Nenhum", "Centro", "3", 59244-000);
    
insert into login (usuario, senha, ativo) values 
	('ManelBMX', 'manoel123', 1),
	('JLCC', 'joaolucas123', 1), 
    ('L0uh3n', 'luizh123', 1), 
    ('FernandoBF', 'bahia123', 1); 
    
insert into cliente (cpf, nome, sobrenome, data_nasc, genero, endereco_id, email, ativo, num_telefone, login_id) values 
	(08954823554, "João Lucas", "Corcino", '2005-03-21', "Masculino", 1, "joaol@gmail.com", 1, "(84) 98568-9851", 2),
	(08598436519, "Luiz Henrique", "Macedo", '2003-06-15', "Masculino", 3, "luizh@gmail.com", 1, "(84) 98823-1081", 3),
	(08165436542, "Fernando Henrique", "Fonseca", '2005-03-23', "Masculino", 2, "bahia_f@gmail.com", 1, "(84) 98422-3457", 4);

insert into funcionario (cpf, nome, sobrenome, data_nasc, genero, endereco_id, email, gerente, ativo, login_id) values 
	(87456322109, 'Manoel Antonio', 'Ferreira', '2004-05-23', 'Masculino', 1, 'manoelbike@gmail.com', 0, 1, 1);

insert into servicos (nome_servico, valor_servico) values 
	("Corte de cabelo", 10.00),
	("Corte de cabelo infantil", 15.00),
	("Corte de cabelo com degradê", 15.00),
	("Progressiva", 50.00),
	("Lavagem de cabelos", 30.00),
	("Barba tradicional", 20.00),
	("Barba somente na máquina", 10.00),
	("Sobrancelha na navalha", 10.00),
	("Sobrancelha na cera/pinça", 15.00),
	("Corte + lavagem", 35.00),
	("Corte + barba tradicional", 25.00),
	("Corte + lavagem + barba tradicional", 55.00);

insert into agendamento (cliente_id, funcionario_id, data_horario) values 
	(1, 1, '2022-10-02 15:00:00'), (2, 1, '2022-10-08 09:00:00'), (3, 1, '2022-10-15 18:00:00'); 
    
insert into servicos_agendamento (servico_id, agendamento_id) values 
	(1, 1), 
    (11, 2), 
    (6, 3); 
    
insert into categoria (tipo_categoria) values 
	('Produtos para barba'), 
	('Produtos para cabelo'), 
	('Produtos para pele'), 
	('Bebidas');
    
insert into produtos (categoria_id, descricao_produto, estoque, preco) values 
	(1, 'Óleo para barba', 40, 45.99), 
	(2, 'Shampoo anti-queda e fortalecimento de fios', 50, 79.99), 
	(3, 'Esfoliante anti-ácne', 30, 36.99), 
	(4, 'Cerveja HEINEKEN', 35, 7.50);
    
insert into pedido (produto_id, cliente_id, data_pedido, qtde, valor_total) values
	(4, 1, '2022-10-12 16:15:00', 1, 7.50),
	(2, 2, '2022-10-21 10:05:00', 1, 79.99), 
	(1, 3, '2022-10-30 19:35:00', 1, 45.99);
    
insert into pagamento (cliente_id, funcionario_id, pedido_id, valor, data_pagamento) values
	(1, 1, 1, 7.50, '2022-10-12 16:15:00'),
    (2, 1, 2, 79.99, '2022-10-21 10:05:00'),
    (3, 1, 3, 45.99, '2022-10-30 19:35:00');
    
# --------------------------------------------------------------------------------------------------------------------------------------------    
-- Selects com inner join:

select cliente.cpf, cliente.nome, cliente.sobrenome, cliente.data_nasc, cliente.genero, cliente.email, login.usuario, login.senha, endereco.logradouro, endereco.numero_casa, endereco.bairro, cidade.cidade, cidade.uf from login
inner join cliente on login.login_id = cliente.login_id
inner join endereco on cliente.endereco_id = endereco.endereco_id
inner join cidade on endereco.cidade_id = cidade.cidade_id where cliente.cliente_id = 1;

select cliente.nome, servicos.nome_servico, agendamento.data_horario, funcionario.nome, servicos.valor_servico from servicos
inner join servicos_agendamento on servicos.servico_id = servicos_agendamento.servico_id
inner join agendamento on servicos_agendamento.agendamento_id = agendamento.agendamento_id
inner join cliente on agendamento.cliente_id = cliente.cliente_id
inner join funcionario on funcionario.funcionario_id = agendamento.funcionario_id where agendamento.agendamento_id = 1; 

select cliente.nome, funcionario.nome, produtos.descricao_produto, categoria.tipo_categoria, pedido.qtde, pagamento.data_pagamento, pagamento.valor from categoria
inner join produtos on categoria.categoria_id = produtos.categoria_id
inner join pedido on produtos.produto_id = pedido.produto_id
inner join cliente on pedido.cliente_id = cliente.cliente_id
inner join pagamento on cliente.cliente_id = pagamento.cliente_id
inner join funcionario on pagamento.funcionario_id = funcionario.funcionario_id where pedido.pedido_id = 1;