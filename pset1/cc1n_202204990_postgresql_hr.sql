
CREATE TABLE cargos (
                id_cargos VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_maximo NUMERIC(8,2),
                salario_minimo NUMERIC(8,2),
                CONSTRAINT id_cargos PRIMARY KEY (id_cargos)
);


CREATE TABLE regios (
                id_regiao CHAR(2) NOT NULL,
                nome_regiao VARCHAR(25) DEFAULT AK NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE regios IS 'Tabela que guardara o dados dos nomes das regioes';
COMMENT ON COLUMN regios.id_regiao IS 'Chave primaria da tabela regios 
';
COMMENT ON COLUMN regios.nome_regiao IS 'Nome da regiao Ex: amererica latina';


CREATE INDEX regios_idx
 ON regios
 ( nome_regiao );

CREATE TABLE paises (
                id_pais INTEGER NOT NULL,
                nome_pais VARCHAR(50) NOT NULL,
                id_regiao CHAR NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON COLUMN paises.id_pais IS 'Chave primaria da tabale paises ';
COMMENT ON COLUMN paises.nome_pais IS 'Nome do pais Ex: Brasil ';
COMMENT ON COLUMN paises.id_regiao IS 'Chave estrangeira para a tabela regioes ';


CREATE TABLE localizacao (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50) NOT NULL,
                uf VARCHAR(25),
                id_pais INTEGER NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON COLUMN localizacao.id_localizacao IS 'Chave primaria da tabela Localização';
COMMENT ON COLUMN localizacao.endereco IS 'Campo de endereço Ex: nome da rua ';
COMMENT ON COLUMN localizacao.cep IS 'Cep postal do endereço ';
COMMENT ON COLUMN localizacao.cidade IS 'Cidade no qual aquele endereço se encontra ';
COMMENT ON COLUMN localizacao.uf IS 'Sigla do estado em que o endereço se encontra ';
COMMENT ON COLUMN localizacao.id_pais IS 'Chave estrangera da tabela paises ';


CREATE TABLE departamentos (
                id_departamentos INTEGER NOT NULL,
                nome_departamento VARCHAR(30) NOT NULL,
                id_localizacao INTEGER NOT NULL,
                id_surpevisor INTEGER NOT NULL,
                CONSTRAINT id_departamentos PRIMARY KEY (id_departamentos)
);
COMMENT ON COLUMN departamentos.id_departamentos IS 'Chave primaria da tabela departamentos ';
COMMENT ON COLUMN departamentos.nome_departamento IS 'Nome do departamento ';
COMMENT ON COLUMN departamentos.id_localizacao IS 'chave estrangera da tabela localicao ';
COMMENT ON COLUMN departamentos.id_surpevisor IS 'Chave primaria da tabela empregados ';


CREATE TABLE empregados (
                id_empregados INTEGER NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                telefone VARCHAR(20),
                id_cargos VARCHAR(10) NOT NULL,
                id_supervisor INTEGER NOT NULL,
                id_departamentos INTEGER NOT NULL,
                CONSTRAINT id_empregados_ PRIMARY KEY (id_empregados)
);
COMMENT ON COLUMN empregados.id_empregados IS 'Chave primaria da tabela empregados ';
COMMENT ON COLUMN empregados.nome_empregado IS 'Nome completo do empregado 
';
COMMENT ON COLUMN empregados.email IS 'email do funcionario';
COMMENT ON COLUMN empregados.data_contratacao IS 'Data de inicio do empregado na empresa ';
COMMENT ON COLUMN empregados.salario IS 'valor de salario que o funcionario recebe';
COMMENT ON COLUMN empregados.comissao IS 'porcentagem da comissao do funcionario caso receba, somente o departamento de vendas e elegivel para comissao';
COMMENT ON COLUMN empregados.telefone IS 'telefone de contato do funcionario';
COMMENT ON COLUMN empregados.id_cargos IS 'Chave estrangera para a tabela de cargos ';
COMMENT ON COLUMN empregados.id_departamentos IS 'Chave primaria da tabela departamentos ';


CREATE TABLE historico_cargos (
                id_empregados INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_departamentos INTEGER NOT NULL,
                CONSTRAINT id_historico_cargos PRIMARY KEY (id_empregados, data_inicial)
);
COMMENT ON COLUMN historico_cargos.data_inicial IS 'Uma coluna não nula na chave primária complexa id_empregado+data_inicial.
Deve ser menor que a data_final da tabela historico_cargos.';
COMMENT ON COLUMN historico_cargos.data_final IS 'ultimo dia do funcionário nesta função. Uma coluna não nula. Deve ser
maior que a data_inicial';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargos)
REFERENCES cargos (id_cargos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE paises ADD CONSTRAINT regios_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regios (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacao ADD CONSTRAINT paises_localizacao_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT localizacao_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacao (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamentos)
REFERENCES departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamentos)
REFERENCES departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregados)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_surpevisor)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
