drop database if exists sisescII;
create database sisescII;
SET GLOBAL log_bin_trust_function_creators = 1;

use sisescII;

# analisar reprovação por frequencia e nota
# analisar insert de aluno quanto a quantidade permitida
# analisar disciolina / aluno
/*
 #
 # CREATE TABLE
 #
 */
/*
 # Acadêmico I
 */
create table tbl_colegiados(
    id_colegiado int not null primary key auto_increment,
    nome varchar(255) not null unique,
    codigo char(3) not null unique
);

create table tbl_cursos(
    id_curso int not null primary key auto_increment,
    fk_id_colegiado int not null,
    nome varchar(255) not null unique,
    codigo char(3) not null unique,
    foreign key(fk_id_colegiado) references tbl_colegiados(id_colegiado)
);

create table tbl_periodos(
    id_periodo int not null primary key auto_increment,
    codigo char(2) not null,
    descricao varchar(60) not null
);

create table tbl_turmas(
    id_turma int not null primary key auto_increment,
    fk_id_curso int not null,
    quantidade_alunos int not null,
    ano char(4) not null,
    data_inicio date not null,
    data_fim date not null,
    fk_id_periodo int not null,
    foreign key(fk_id_curso) references tbl_cursos(id_curso),
    foreign key(fk_id_periodo) references tbl_periodos(id_periodo)
);

create table tbl_disciplinas(
    id_disciplina int not null primary key auto_increment,
    nome varchar(255) not null
);

/*
 # Usuário 
 */
create table tbl_sexos(
    id_sexo int not null primary key auto_increment,
    descricao varchar(60) not null
);

create table tbl_estados(
    id_estado int not null primary key auto_increment,
    descricao varchar(60) not null
);

create table tbl_usuarios(
    id_usuario int not null primary key auto_increment,
    nome varchar(255) not null,
    sobrenome varchar(255) not null,
    cpf char(11) not null unique,
    fk_id_estado int not null,
    fk_id_sexo int not null,
    email varchar(255) not null unique,
    pai varchar(255) not null,
    mae varchar(255) not null,
    foreign key(fk_id_estado) references tbl_estados(id_estado),
    foreign key(fk_id_sexo) references tbl_sexos(id_sexo)
);

create table tbl_login(
    login char(11) not null primary key,
    fk_id_usuario int not null,
    senha varchar(14) not null default '1234567',
    foreign key(fk_id_usuario) references tbl_usuarios(id_usuario)
);

/*
 # Aluno
 */
create table tbl_alunos(
    id_aluno int not null primary key auto_increment,
    fk_id_usuario int not null,
    fk_id_turma int not null,
    matricula char(11) not null unique,
    #trigger
    foreign key(fk_id_usuario) references tbl_usuarios(id_usuario),
    foreign key(fk_id_turma) references tbl_turmas(id_turma)
);

/*
 # Funcionario 
 */
create table tbl_funcionarios(
    id_funcionario int not null primary key auto_increment,
    matricula char(6) not null unique default 'F00001',
    #trigger
    data_ingresso date not null,
    fk_id_usuario int not null,
    foreign key(fk_id_usuario) references tbl_usuarios(id_usuario)
);

create table tbl_professores(
    id_professor int not null primary key auto_increment,
    fk_id_funcionario int not null,
    fk_id_curso int not null,
    foreign key(fk_id_funcionario) references tbl_funcionarios(id_funcionario),
    foreign key(fk_id_curso) references tbl_cursos(id_curso)
);

create table tbl_coordenadores(
    id_coordenador int not null primary key auto_increment,
    fk_id_professor int not null,
    data_inicio date not null,
    data_fim date,
    foreign key(fk_id_professor) references tbl_professores(id_professor)
);

/*
 # Endereço 
 */
create table tbl_ufs(
    id_uf int not null primary key auto_increment,
    nome varchar(255) not null,
    descricaco varchar(255)
);

create table tbl_cidades(
    id_cidade int not null primary key auto_increment,
    fk_id_uf int not null,
    nome varchar(255) not null,
    descricao varchar(255),
    foreign key(fk_id_uf) references tbl_ufs(id_uf)
);

create table tbl_bairros(
    id_bairro int not null primary key auto_increment,
    fk_id_cidade int not null,
    nome varchar(255) not null,
    descricao varchar(255),
    foreign key(fk_id_cidade) references tbl_cidades(id_cidade)
);

create table tbl_ceps(
    id_cep int not null primary key auto_increment,
    cep char(8) not null
);

create table tbl_tipo_logradouros(
    id_tipo_logradouro int not null primary key auto_increment,
    descricao varchar(255) not null
);

create table tbl_logradouros(
    id_logradouro int not null primary key auto_increment,
    fk_id_bairro int not null,
    fk_id_tipo_logradouro int not null,
    fk_id_cep int not null,
    nome varchar(255) not null,
    descricao varchar(255),
    foreign key(fk_id_bairro) references tbl_bairros(id_bairro),
    foreign key(fk_id_tipo_logradouro) references tbl_bairros(id_bairro),
    foreign key(fk_id_cep) references tbl_ceps(id_cep)
);

create table tbl_enderecos(
    id_endereco int not null primary key auto_increment,
    fk_id_usuario int not null,
    #por que não coloca como pk?
    fk_id_logradouro int not null,
    numero varchar(10) not null,
    complemento varchar(255),
    foreign key(fk_id_usuario) references tbl_usuarios(id_usuario),
    foreign key(fk_id_logradouro) references tbl_logradouros(id_logradouro)
);

/*
 # Telefone  
 */
create table tbl_tipo_telefone(
    id_tipo_telefone int not null primary key auto_increment,
    nome varchar(255) not null
);

create table tbl_ddd(
    id_ddd int not null primary key auto_increment,
    ddd char(2) not null
);

create table tbl_telefones(
    id_telefone int not null primary key auto_increment,
    fk_id_tipo_telefone int not null,
    fk_id_usuario int not null,
    fk_id_ddd int not null,
    numero varchar(10) unique,
    foreign key(fk_id_tipo_telefone) references tbl_tipo_telefone(id_tipo_telefone),
    foreign key(fk_id_usuario) references tbl_usuarios(id_usuario),
    foreign key(fk_id_ddd) references tbl_ddd(id_ddd)
);

/*
 # Acadêmico II
 */
create table tbl_semestres(
    id_semestre int not null primary key auto_increment,
    data_inicio date not null unique,
    data_fim date not null unique,
    descricao varchar(255) not null unique
);

create table tbl_curso_disciplina_obrigatoriedade (
    id_curso_disciplina_obrigatoriedade int not null primary key auto_increment,
    descricao varchar(20) not null unique
);

create table tbl_curso_disciplina(
    id_curso_disciplina int not null primary key auto_increment,
    fk_id_curso int not null,
    fk_id_disciplina int not null,
    fk_id_obrigatoriedade int not null,
    carga_horaria int not null,
    quantidade_alunos int not null,
    foreign key(fk_id_curso) references tbl_cursos(id_curso),
    foreign key(fk_id_disciplina) references tbl_disciplinas(id_disciplina),
    foreign key(fk_id_obrigatoriedade) references tbl_curso_disciplina_obrigatoriedade(id_curso_disciplina_obrigatoriedade)
);

create table tbl_curso_disciplina_semestre(
    id_curso_disciplina_semestre int not null primary key auto_increment,
    fk_id_curso_disciplina int not null,
    fk_id_semestre int not null,
    foreign key(fk_id_curso_disciplina) references tbl_curso_disciplina(id_curso_disciplina),
    foreign key(fk_id_semestre) references tbl_semestres(id_semestre)
);

create table tbl_aluno_disciplina(
    id_aluno_disciplina int not null primary key auto_increment,
    fk_id_aluno int not null,
    fk_id_curso_disciplina_semestre int not null,
    foreign key(fk_id_aluno) references tbl_alunos(id_aluno),
    foreign key(fk_id_curso_disciplina_semestre) references tbl_curso_disciplina_semestre(id_curso_disciplina_semestre)
);

create table tbl_professor_disciplina(
    id_professor_disciplina int not null primary key auto_increment,
    fk_id_professor int not null,
    fk_id_curso_disciplina_semestre int not null,
    foreign key(fk_id_professor) references tbl_professores(id_professor),
    foreign key(fk_id_curso_disciplina_semestre) references tbl_curso_disciplina_semestre(id_curso_disciplina_semestre)
);

create table tbl_situacao(
    id_situacao int not null primary key auto_increment,
    descricao varchar(255) not null unique
);

create table tbl_historicos(
    id_historico_disciplina int not null primary key auto_increment,
    fk_id_aluno int not null,
    fk_id_curso_disciplina_semestre int not null,
    fk_id_situacao int not null,
    nota float not null,
    frequencia int not null,
    #Avaliar se freqencia não é maior que carga horária
    foreign key(fk_id_situacao) references tbl_situacao(id_situacao),
    foreign key(fk_id_aluno) references tbl_alunos(id_aluno),
    foreign key(fk_id_curso_disciplina_semestre) references tbl_curso_disciplina_semestre(id_curso_disciplina_semestre)
);

create table tbl_disciplina_dependente(
    id_disciplina_dependente int not null primary key auto_increment,
    fk_id_curso_disciplina int not null,
    fk_id_disciplina_requisito int not null,
    carga_horaria_minima int not null,
    foreign key(fk_id_curso_disciplina) references tbl_curso_disciplina(id_curso_disciplina),
    foreign key(fk_id_disciplina_requisito) references tbl_disciplinas(id_disciplina)
);

/*
 #
 # VIEWS
 #
 */
drop view if exists vw_turma_curso;

create view vw_turma_curso as
select
    turma.id_turma as ID_TURMA,
    turma.ano as TURMA,
    curso.nome as CURSO,
    curso.codigo as CODIGO_CURSO,
    periodo.descricao as PERIODO,
    periodo.codigo as CODIGO_PERIODO,
    turma.quantidade_alunos as QUANTIDADE_ALUNOS,
    curso.id_curso as ID_CURSO
from
    tbl_turmas as turma
    join tbl_periodos as periodo on (turma.fk_id_periodo = periodo.id_periodo)
    join tbl_cursos as curso on (turma.fk_id_curso = curso.id_curso)
    join tbl_colegiados as colegiado on (curso.fk_id_colegiado = colegiado.id_colegiado);

drop view if exists vw_aluno_usuario;

create view vw_aluno_usuario as
select
    usuario.nome as NOME,
    usuario.sobrenome as SOBRENOME,
    usuario.cpf as CPF,
    aluno.matricula as MATRICULA,
    turma.curso as CURSO,
    turma.turma as TURMA,
    turma.periodo as PERIODO,
    usuario.id_usuario as ID_USUARIO,
    aluno.id_aluno as ID_ALUNO
from
    tbl_alunos as aluno
    join tbl_usuarios as usuario on (aluno.fk_id_usuario = usuario.id_usuario)
    join vw_turma_curso as turma on (aluno.fk_id_turma = turma.id_turma);

drop view if exists vw_colegiado_curso;

create view vw_colegiado_curso as
select
    curso.id_curso as ID_CURSO,
    curso.nome as CURSO,
    curso.codigo as CODIGO_CURSO,
    colegiado.nome as COLEGIADO,
    colegiado.codigo as CODIG_COLEGIADO,
    colegiado.id_colegiado as ID_COLEGIADO
from
    tbl_cursos as curso
    join tbl_colegiados as colegiado on (curso.fk_id_colegiado = colegiado.id_colegiado);

drop view if exists vw_professor_usuario;

create view vw_professor_usuario as
select
    usuario.nome as NOME,
    usuario.sobrenome as SOBRENOME,
    usuario.cpf as CPF,
    funcionario.matricula as MATRICULA,
    cc.curso as CURSO,
    cc.colegiado as COLEGIADO,
    usuario.id_usuario as ID_USUARIO,
    professor.id_professor as ID_PROFESSOR,
    funcionario.id_funcionario as ID_FUNCIONARIO
from
    tbl_funcionarios as funcionario
    join tbl_usuarios as usuario on (funcionario.fk_id_usuario = usuario.id_usuario)
    join tbl_professores as professor on (
        professor.fk_id_funcionario = funcionario.id_funcionario
    )
    join vw_colegiado_curso as cc on (professor.fk_id_curso = cc.id_curso);

drop view if exists vw_curso_disciplina;

create view vw_curso_disciplina as
select
    curso.nome as CURSO,
    curso.codigo as CODIGO_CURSO,
    disciplina.id_disciplina as ID_DISCIPLINA,
    disciplina.nome as DISCIPLINA,
    cd.carga_horaria as CARGA_HORARIA,
    cd.quantidade_alunos as QUANTIDADE_ALUNOS,
    cd.id_curso_disciplina as ID_CURSO_DISCIPLINA
from
    tbl_curso_disciplina as cd
    join tbl_disciplinas as disciplina on (cd.fk_id_disciplina = disciplina.id_disciplina)
    join tbl_cursos as curso on (cd.fk_id_curso = curso.id_curso);

drop view if exists vw_curso_disciplina_semestre;

create view vw_curso_disciplina_semestre as
select
    cd.*,
    semestre.descricao as SEMESTRE,
    cds.id_curso_disciplina_semestre as ID_CURSO_DISCIPLINA_SEMESTRE
from
    tbl_curso_disciplina_semestre as cds
    join vw_curso_disciplina as cd on (
        cds.fk_id_curso_disciplina = cd.id_curso_disciplina
    )
    join tbl_semestres as semestre on (cds.fk_id_semestre = semestre.id_semestre);

drop view if exists vw_historico;
create view vw_historico as
select
	ID_ALUNO,
    aluno.nome as NOME,
    aluno.sobrenome as SOBRENOME,
    ID_DISCIPLINA,
    cds.disciplina as DISCIPLINA,
    cds.curso as CURSO,
    CARGA_HORARIA,
    ID_CURSO_DISCIPLINA,
    cds.semestre as SEMESTRE,
    historico.nota as NOTA,
    historico.frequencia as FREQUENCIA,
    situacao.descricao as RESULTADO
from
    tbl_historicos as historico
    join vw_aluno_usuario as aluno on (historico.fk_id_aluno = aluno.id_aluno)
    join vw_curso_disciplina_semestre as cds on (
        historico.fk_id_curso_disciplina_semestre = cds.id_curso_disciplina_semestre
    )
    join tbl_situacao as situacao on (historico.fk_id_situacao = situacao.id_situacao);

drop view if exists vw_professor_disciplina;
create view vw_professor_disciplina as
select
	ID_PROFESSOR,
    cds.disciplina as DISCIPLINA,
    cds.curso as CURSO,
    cds.semestre as SEMESTRE,
    professor.nome as NOME,
    professor.sobrenome as SOBRENOME,
    professor.matricula as MATRICULA,
    professor.curso as CURSO_PROFESSOR
from
    tbl_professor_disciplina as pd
    join vw_curso_disciplina_semestre as cds on (
        pd.fk_id_curso_disciplina_semestre = cds.id_curso_disciplina_semestre
    )
    join vw_professor_usuario as professor on (pd.fk_id_professor = professor.id_professor);


drop view if exists vw_endereco;
create view vw_endereco as
select
    id_endereco as ID_ENDERECO,
    fk_id_usuario as ID_USUARIO,
    tbl_tipo_logradouros.descricao as TIPO_LOGRADOURO,
    tbl_logradouros.nome as LOGRADOURO,
    numero as NUMERO,
    tbl_bairros.nome as BAIRRO,
    complemento as COMPLEMENTO,
    tbl_ceps.cep as CEP,
    tbl_cidades.nome as CIDADE,
    tbl_ufs.nome as UF
from
    tbl_enderecos
    join tbl_logradouros on fk_id_logradouro = tbl_logradouros.id_logradouro
    join tbl_tipo_logradouros on tbl_logradouros.fk_id_tipo_logradouro = tbl_tipo_logradouros.id_tipo_logradouro
    join tbl_bairros on tbl_logradouros.fk_id_bairro = tbl_bairros.id_bairro
    join tbl_ceps on tbl_logradouros.fk_id_cep = tbl_ceps.id_cep
    join tbl_cidades on fk_id_cidade = tbl_cidades.id_cidade
    join tbl_ufs on fk_id_uf = tbl_ufs.id_uf;

drop view if exists vw_funcionario;
create view vw_funcionario as
select
    usuario.id_usuario as ID_USUARIO,
    id_funcionario as ID_FUNCIONARIO,
    matricula as MATRICULA,
    data_ingresso as DATA_ENGRESSO,
    concat(usuario.nome, " ", usuario.sobrenome) as NOME,
    usuario.cpf as CPF,
    tbl_sexos.descricao as SEXO,
    usuario.email as EMAIL,
    tbl_estados.descricao as ESTADO,
    usuario.pai as PAI,
    usuario.mae as MAE
from
    tbl_funcionarios
    join tbl_usuarios as usuario on (
        tbl_funcionarios.fk_id_usuario = usuario.id_usuario
    )
    join tbl_estados on usuario.fk_id_estado = tbl_estados.id_estado
    join tbl_sexos on usuario.fk_id_sexo = tbl_sexos.id_sexo;

drop view if exists vw_aluno_disciplina;
create view vw_aluno_disciplina as
select
    id_aluno_disciplina as ID_ALUNO_DISCIPLINA,
    vw_aluno_usuario.*,
    DISCIPLINA,
    SEMESTRE,
    ID_CURSO_DISCIPLINA_SEMESTRE
from
    tbl_aluno_disciplina
    join vw_aluno_usuario on tbl_aluno_disciplina.fk_id_aluno = vw_aluno_usuario.ID_ALUNO
    join vw_curso_disciplina_semestre on tbl_aluno_disciplina.fk_id_curso_disciplina_semestre = vw_curso_disciplina_semestre.ID_CURSO_DISCIPLINA_SEMESTRE;

drop view if exists vw_telefone_usuario;
create view vw_telefone_usuario as
select
    id_telefone as ID_TELEFONE,
    fk_id_usuario as ID_USUARIO,
    tbl_tipo_telefone.nome as TIPO,
    tbl_ddd.ddd as DDD,
    numero as NUMERO
from
    tbl_telefones
    join tbl_tipo_telefone on fk_id_tipo_telefone = tbl_tipo_telefone.id_tipo_telefone
    join tbl_ddd on fk_id_ddd = tbl_ddd.id_ddd;

drop view if exists vw_disciplina_dependente;
create view vw_disciplina_dependente as
select
 vw_curso_disciplina.*,
 id_disciplina_dependente as ID_DISCIPLINA_DEPENDENTE,
 tbl_disciplinas.id_disciplina as ID_DISCIPLINA_REQUISITO,
 tbl_disciplinas.nome as NOME_DISCIPLINA_REQUISITO,
 carga_horaria_minima as CH_DISCIPLINA_REQUISITO
from
 tbl_disciplina_dependente
join tbl_disciplinas on fk_id_disciplina_requisito = tbl_disciplinas.id_disciplina
join vw_curso_disciplina on fk_id_curso_disciplina = vw_curso_disciplina.ID_CURSO_DISCIPLINA; 
/*
 #
 # PROCEDIMENTOS
 #
 */
drop procedure if exists pr_matricula_aluno;

drop procedure if exists pr_carga_horaria_disciplina;

drop procedure if exists pr_quantidade_alunos_turma;

drop procedure if exists pr_quantidade_alunos_disciplina;

delimiter $ 
create procedure pr_matricula_aluno(in fk_id_turma int, out matricula char(11)) begin declare a varchar(255);

declare b varchar(255);

declare c varchar(255);

declare d varchar(255);

declare e varchar(255);

declare f int;

declare g varchar(255);

declare h varchar(255);

select
    curso
from
    vw_turma_curso
where
    id_turma = fk_id_turma into a;

select
    codigo_curso
from
    vw_turma_curso
where
    id_turma = fk_id_turma into b;

select
    periodo
from
    vw_turma_curso
where
    id_turma = fk_id_turma into c;

select
    codigo_periodo
from
    vw_turma_curso
where
    id_turma = fk_id_turma into d;

select
    turma
from
    vw_turma_curso
where
    id_turma = fk_id_turma into e;

select
    count(*)
from
    vw_aluno_usuario
where
    curso = a
    and periodo = c
    and turma = e into f;

set
    f = f + 1;

if f < 10 then
select
    concat('0', f) into g;

select
    concat(e, b, d, g) into h;

set
    matricula = h;

else
select
    concat('', f) into g;

select
    concat(e, b, d, g) into h;

set
    matricula = h;

end if;

end $ 

create procedure pr_carga_horaria_disciplina(in id int, out ch int) begin declare a int;

select
    carga_horaria
from
    vw_curso_disciplina_semestre
where
    id_curso_disciplina_semestre = id into a;

set
    ch = a;

end $ create procedure pr_quantidade_alunos_disciplina(in id int, out qa int) begin declare a int;

select
    quantidade_alunos
from
    vw_curso_disciplina_semestre
where
    id_curso_disciplina_semestre = id into a;

set
    qa = a;

end $ 

create procedure pr_quantidade_alunos_turma(in id int, out qa int) begin declare a int;

select
    quantidade_alunos
from
    vw_turma_curso
where
    id_turma = id into a;

set
    qa = a;

end $ 

delimiter ;

/*
 #
 #	TRIGGERS
 #  
 */
drop trigger if exists tr_criar_login;

drop trigger if exists tr_matricula_aluno;

drop trigger if exists tr_matricula_funcionario;

delimiter $$
create trigger tr_criar_login
after
insert
    on tbl_usuarios for each row begin
insert into
    tbl_login (login, fk_id_usuario)
values
    (NEW.cpf, NEW.id_usuario);

end $$

delimiter ;
delimiter $$
create trigger tr_situacao_aluno before
insert
    on tbl_historicos for each row begin call pr_carga_horaria_disciplina(
        new.fk_id_curso_disciplina_semestre,
        @condicional
    );

if NEW.nota < 5
or NEW.frequencia < 0.75 * @condicional then
set
    NEW.fk_id_situacao = 2;

else
set
    NEW.fk_id_situacao = 1;

end if;

end $$

delimiter ;

delimiter $$
create trigger tr_aluno_disciplina before
insert
    on tbl_aluno_disciplina for each row begin declare contador int;

call pr_quantidade_alunos_disciplina(
    new.fk_id_curso_disciplina_semestre,
    @condicional
);

select
    count(*)
from
    tbl_aluno_disciplina
where
    fk_id_curso_disciplina_semestre = new.fk_id_curso_disciplina_semestre into contador;

if contador >= @condicional then
set
    NEW.id_aluno_disciplina = null;

end if;

end $$


delimiter ;

delimiter $$

create trigger tr_matricula_funcionario before
insert
    on tbl_funcionarios for each row begin declare resultado char(6);

declare aux int;

select
    max(id_funcionario)
from
    tbl_funcionarios into aux;

if aux is not null then
set
    aux = aux + 1;

if aux < 10 then
select
    concat('F0000', aux) into resultado;

set
    new.matricula = resultado;

elseif aux < 100 then
select
    concat('F000', aux) into resultado;

set
    new.matricula = resultado;

elseif aux < 1000 then
select
    concat('F00', aux) into resultado;

set
    new.matricula = resultado;

elseif aux < 10000 then
select
    concat('F0', aux) into resultado;

set
    new.matricula = resultado;

else
select
    concat('F', aux) into resultado;

set
    new.matricula = resultado;

end if;

else
set
    new.matricula = 'F00001';

end if;

end $$

delimiter ;

delimiter $$

create trigger tr_matricula_aluno before
insert
    on tbl_alunos for each row begin #matrícula será a união de ano + codigo_curso + codigo_periodo + contador
    #Ex: 20170010101 ou 20170010123
    declare contador int;

call pr_quantidade_alunos_turma(NEW.fk_id_turma, @condicional);

select
    count(*)
from
    tbl_alunos
where
    fk_id_turma = NEW.fk_id_turma into contador;

if contador < @condicional then call pr_matricula_aluno(NEW.fk_id_turma, @matricula);

set
    NEW.matricula = @matricula;

else
set
    NEW.id_aluno = null;

end if;

end $$

delimiter ;


drop procedure if exists pr_cadastra_aluno;

delimiter $$
create procedure pr_cadastra_aluno(nome varchar(255), sobrenome varchar(255), n_cpf varchar(255), email varchar(255), sexo int, estado int, pai varchar(255), mae varchar(255), turma int)
begin
	if ( nome = '' || nome is null || sobrenome = '' || sobrenome is null || n_cpf = '' || n_cpf is null || email = '' || email is null || pai = '' || mae = '' || sexo is null || estado is null || sexo <= 0 || estado <= 0 || turma is null || turma<= 0 ) then
        select 'Campos invalidos';
    else
        insert into tbl_usuarios values (
        null,
        nome,
        sobrenome,
        n_cpf,
        estado,
        sexo,
        email,
        pai,
        mae);
        
        select id_usuario into @id_user from tbl_usuarios where cpf = n_cpf;
		insert into tbl_alunos (fk_id_usuario, fk_id_turma) values (@id_user, turma);
        select 'Aluno inserido';
	end if;
end $$

delimiter ;

drop procedure if exists pr_matricula_aluno_disciplina;
call pr_matricula_aluno_disciplina(5, 1, '2019.1');
delimiter $$
create procedure pr_matricula_aluno_disciplina(aluno int, id_disciplina_semestre int, n_semestre varchar(7))
begin
	if(aluno <= 0 || aluno is null || id_disciplina_semestre <= 0 || id_disciplina_semestre is null || n_semestre is null || n_semestre = '') then
		select 'Argumentos invalidos';
	end if;
    
    select ID_DISCIPLINA into @targetDisciplina from vw_curso_disciplina_semestre where ID_CURSO_DISCIPLINA_SEMESTRE = id_disciplina_semestre;
    select fn_verifica_reprovado_3(aluno, @targetDisciplina) into @isReprovado;
    if( @isReprovado = 1 ) then select 'O aluno ja reprovou nesta disciplina 3 vezes!'; end if;

    select ID_DISCIPLINA_DEPENDENTE, CH_DISCIPLINA_REQUISITO INTO @id_disc_req, @ch_req from vw_disciplina_dependente where ID_CURSO_DISCIPLINA = id_disciplina_semestre;
    if(@id_disc_req is not null) then
		select fn_checa_disciplina_requisito(aluno, @id_disc_req, @ch_req) into @isValid;
		if ( @isValid = 0 ) then select 'O aluno não pode se matricular pois não tem o requisito da matéria'; end if;
    end if;
    select count(*) into @ja_matriculado from vw_aluno_disciplina where ID_ALUNO = aluno and SEMESTRE = n_semestre and ID_CURSO_DISCIPLINA_SEMESTRE = id_disciplina_semestre;
    if( @ja_matriculado > 0 ) then 
		select 'O aluno ja esta matriculado nesta disciplina!'; 
	end if;
    
    select count(*) into @num_materias from vw_aluno_disciplina where ID_ALUNO = aluno && SEMESTRE = n_semestre;
    if ( @num_materias < 10 ) then
        insert into tbl_aluno_disciplina values (null, aluno, id_disciplina_semestre);
        select 'Aluno se matriculou!';
    else
        select concat('Aluno ja atingiu o número maximo de materias para o semeste ', n_semestre);
	end if;
end $$

delimiter ;

drop procedure if exists pr_tranca_matricula_aluno;
delimiter $$
create procedure pr_tranca_matricula_aluno(aluno int, n_semestre varchar(10))
begin
	if(aluno = 0 || aluno is null || n_semestre = '' || n_semestre is null ) then
		select 'Argumentos inválidos';
	end if;

	select count(*), NOME into @isValid, @aluno from vw_aluno_disciplina where ID_USUARIO = aluno and SEMESTRE = n_semestre;
	if ( @isValid = 0 ) then 
		select concat('O aluno ', @aluno, ' trancou o semestre!');
	else
		select concat('Não é possivel trancar o semestre pois o aluno ', @aluno, ' esta matriculado em ', @isValid, ' disciplinas!' );
    end if;
    
end $$
delimiter ;

drop procedure if exists pr_matricula_professor_disciplina;
delimiter $$
create procedure pr_matricula_professor_disciplina(professor int, disc_semestre int, n_semestre varchar(10))
begin 
	if ( professor = '' || professor is null || disc_semestre = '' || disc_semestre is null || n_semestre = '' || n_semestre is null ) then
        select 'Campos invalidos';
	end if;
	select count(*) into @isValid from vw_professor_disciplina where ID_PROFESSOR = professor and SEMESTRE = n_semestre;
	if(@isValid < 4) then
		insert into tbl_professor_disciplina(fk_id_professor, fk_id_curso_disciplina_semestre) values (professor, disc_semestre);
	else 
		select concat('O professor só pode esta matriculado em no máximo 5 disciplinas!');
    end if;
end $$
delimiter ; 

/*
 -- FUNÇÕES
*/

drop function if exists fn_checa_disciplina_requisito;
delimiter $$
create function fn_checa_disciplina_requisito(aluno int, disciplina_dependente int, hora_min int) returns bool
begin
	select COUNT(*) INTO @is_valid from vw_historico where ID_ALUNO = aluno and ID_CURSO_DISCIPLINA = disciplina_dependente and RESULTADO = "APROVADO" and CARGA_HORARIA >= hora_min;
    if (@is_valid = 0) then 
		return false;
	end if;
    return true;
end $$
delimiter ;

drop function if exists fn_verifica_reprovado_3;

delimiter $$
create function fn_verifica_reprovado_3(aluno int, n_disciplina int) returns bool
begin
	select count(*) into @isValid from vw_historico where ID_ALUNO = aluno and ID_DISCIPLINA = n_disciplina and RESULTADO = "REPROVADO";
    if ( @isValid = 3 ) then 
		return true;
	else 
		return false;
	end if;
end $$
delimiter ;

/*
 #
 #	INSERTS
 #	Depois coloque todos aqui   
 */
/*
 # Acedêmico I
 */
insert into
    tbl_colegiados (id_colegiado, nome, codigo)
values
    (1, 'Ciências Exatas e Tecnologia', '001');

insert into
    tbl_cursos (id_curso, fk_id_colegiado, nome, codigo)
values
    (1, 1, 'Ciência da Computação', '001');

insert into
    tbl_periodos (id_periodo, codigo, descricao)
values
    (1, '01', 'MATUTINO'),
    (2, '02', 'VESPERTINO'),
    (3, '03', 'NOTURNO'),
    (4, '04', 'INTEGRAL');

insert into
    tbl_turmas (
        id_turma,
        fk_id_curso,
        quantidade_alunos,
        ano,
        data_inicio,
        data_fim,
        fk_id_periodo
    )
values
    (1, 1, 60, '2017', '2017-02-01', '2021-07-01', 3);

insert into
    tbl_disciplinas (id_disciplina, nome)
values
    (1, 'Cálculo I'),
    (2, 'Programação I'),
    (3, 'Redes de Computadores'),
    (4, 'Física I'),
    (5, 'Matemática Discreta'),
    (6, 'Física II'),
    (7, 'Cálculo II');

/*
 # Usuários
 */
insert into
    tbl_sexos (id_sexo, descricao)
values
    (1, 'HOMEM'),
    (2, 'MULHER'),
    (3, 'NÃO DEFINIDO');

insert into
    tbl_estados (id_estado, descricao)
values
    (1, 'ATIVO'),
    (2, 'INATIVO');

insert into
    tbl_usuarios (
        id_usuario,
        nome,
        sobrenome,
        cpf,
        email,
        fk_id_sexo,
        fk_id_estado,
        pai,
        mae
    )
values
    (
        1,
        'Lucas',
        'Zampar',
        '11111111111',
        'lucas@gmail.com',
        1,
        1,
        'João',
        'Maria'
    ),
    (
        2,
        'Manoel',
        'Gomes',
        '22222222222',
        'manoel@gmail.com',
        1,
        1,
        'João',
        'Maria'
    ),
    (
        3,
        'Camila',
        'Almeida',
        '33333333333',
        'camila@gmail.com',
        2,
        1,
        'João',
        'Maria'
    ),
    (
        4,
        'Alender',
        'Melo',
        '44444444444',
        'alender@gmail.com',
        3,
        1,
        'João',
        'Maria'
    ),
    (
        5,
        'Emanuel',
        'Silva',
        '55555555555',
        'emanuel@gmail.com',
        1,
        1,
        'João',
        'Maria'
    ),
    (
        6,
        'Thiago',
        'Souza',
        '66666666666',
        'thiago@gmail.com',
        1,
        1,
        'João',
        'Maria'
    ),
    (
        7,
        'Júlio',
        'Furtado',
        '77777777777',
        'julio@gmail.com',
        1,
        1,
        'João',
        'Maria'
    ),
    (
        8,
        'Cláudio',
        'Silva',
        '88888888888',
        'claudio@gmail.com',
        1,
        1,
        'João',
        'Maria'
    );

/*
 # Alunos
 */
insert into
    tbl_alunos (fk_id_usuario, fk_id_turma)
values
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1);

/*
 # Funcionários
 */
insert into
    tbl_funcionarios (id_funcionario, fk_id_usuario, data_ingresso)
values
    (1, 5, '2015-08-01'),
    (2, 6, '2015-08-01'),
    (3, 7, '2015-08-01'),
    (4, 8, '2015-08-01');

insert into
    tbl_professores (id_professor, fk_id_funcionario, fk_id_curso)
values
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 1);

insert into
    tbl_coordenadores (fk_id_professor, data_inicio)
values
    (1, '2018-08-01');

/*
 # Enderecos
 */
insert into
    tbl_ufs (id_uf, nome)
values
    (1, 'Amapá');

insert into
    tbl_cidades (id_cidade, fk_id_uf, nome)
values
    (1, 1, 'Macapá'),
    (2, 1, 'Santana');

insert into
    tbl_bairros (id_bairro, fk_id_cidade, nome)
values
    (1, 2, 'Vila Amazonas'),
    (2, 1, 'Laguinho'),
    (3, 2, 'Hospitalidade'),
    (4, 1, 'Centro');

insert into
    tbl_ceps
values
    (1, '68926194'),
    (2, '68908210'),
    (3, '68925153'),
    (4, '33333444');

insert into
    tbl_tipo_logradouros
values
    (1, 'RUA'),
    (2, 'AVENIDA');

insert into
    tbl_logradouros (
        id_logradouro,
        fk_id_bairro,
        fk_id_cep,
        fk_id_tipo_logradouro,
        nome
    )
values
    (1, 1, 1, 1, 'D5 A'),
    (2, 2, 2, 1, 'José Bonifácio'),
    (3, 3, 3, 2, 'Rio Branco'),
    (4, 4, 4, 2, 'Palmeiras');

insert into
    tbl_enderecos (fk_id_usuario, fk_id_logradouro, numero)
values
    (1, 1, '111'),
    (2, 2, '222'),
    (3, 3, '333'),
    (4, 4, '444');

/*
 # Telefones
 */
insert into
    tbl_tipo_telefone (id_tipo_telefone, nome)
values
    (1, 'Celular'),
    (2, 'Fixo');

insert into
    tbl_ddd (id_ddd, ddd)
values
    (1, '96');

insert into
    tbl_telefones (
        fk_id_usuario,
        fk_id_tipo_telefone,
        fk_id_ddd,
        numero
    )
values
    (1, 1, 1, '911112222'),
    (2, 1, 1, '911112223'),
    (3, 1, 1, '911112224'),
    (4, 1, 1, '911112225');

/*
 # Acedêmico II
 */
insert into
    tbl_semestres (id_semestre, data_inicio, data_fim, descricao)
values
    (1, '2019-02-01', '2019-07-01', '2019.1'),
    (2, '2019-08-1', '2019-01-01', '2019.2');

insert into
    tbl_curso_disciplina_obrigatoriedade
values
    (1, 'OBRIGATÓRIA'),
    (2, 'OPTATIVA');

insert into
    tbl_curso_disciplina (
        id_curso_disciplina,
        fk_id_curso,
        fk_id_disciplina,
        fk_id_obrigatoriedade,
        carga_horaria,
        quantidade_alunos
    )
values
    (1, 1, 1, 1, 60, 40),
    (2, 1, 2, 1, 60, 40),
    (3, 1, 3, 1, 60, 40),
    (4, 1, 4, 1, 60, 40),
    (5, 1, 5, 1, 60, 40),
    (6, 1, 6, 1, 60, 40),
    (7, 1, 7, 1, 60, 40);

insert into
    tbl_curso_disciplina_semestre (fk_id_curso_disciplina, fk_id_semestre)
values
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1);

insert into
    tbl_aluno_disciplina (fk_id_aluno, fk_id_curso_disciplina_semestre)
values
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5);

insert into
    tbl_professor_disciplina (fk_id_professor, fk_id_curso_disciplina_semestre)
values
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

insert into
    tbl_situacao (id_situacao, descricao)
values
    (1, 'APROVADO'),
    (2, 'REPROVADO');

insert into
    tbl_historicos(
        fk_id_aluno,
        fk_id_curso_disciplina_semestre,
        nota,
        frequencia,
        fk_id_situacao
    )
values
    (1, 1, 10, 60, 1),
    (1, 2, 10, 60, 1),
    (1, 3, 10, 60, 1),
    (1, 4, 10, 60, 1),
    (1, 5, 10, 60, 1),
    (2, 1, 10, 60, 1),
    (2, 2, 10, 60, 1),
    (2, 3, 10, 60, 1),
    (2, 4, 10, 60, 1),
    (2, 5, 10, 60, 1),
    (3, 1, 10, 60, 1),
    (3, 2, 10, 60, 1),
    (3, 3, 10, 60, 1),
    (3, 4, 10, 60, 1),
    (3, 5, 10, 60, 1),
    (4, 1, 10, 60, 1),
    (4, 2, 10, 60, 1),
    (4, 3, 10, 60, 1),
    (4, 4, 10, 60, 1),
    (4, 5, 10, 60, 1);

insert into tbl_disciplina_dependente values (null, 6, 4, 40), (null, 7, 1, 60);

call pr_cadastra_aluno('Mathes' , 'Costa', '33222222233', 'matheus@gmail.com', 1, 1, 'Joao', 'Maria', 1);

select * from vw_aluno_disciplina where ID_ALUNO = 5 && SEMESTRE = '2019.1';

call pr_matricula_aluno_disciplina(1, 1, '2019.1');

select * from vw_disciplina_dependente;

select * from vw_curso_disciplina_semestre;


