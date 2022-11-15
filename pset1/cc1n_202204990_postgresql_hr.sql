
CREATE TABLE hr.cargos (
                id_cargos VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_maximo NUMERIC(8,2),
                salario_minimo NUMERIC(8,2),
                CONSTRAINT id_cargos PRIMARY KEY (id_cargos),
				UNIQUE(cargo)
);


CREATE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE UNIQUE INDEX cargos_idx1
 ON hr.cargos
 ( cargo );

CREATE TABLE hr.regios (
                id_regiao CHAR(2) NOT NULL,
                nome_regiao VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao),
				UNIQUE(nome_regiao)
);
COMMENT ON TABLE hr.regios IS 'Tabela que guardara o dados dos nomes das regioes';
COMMENT ON COLUMN hr.regios.id_regiao IS 'Chave primaria da tabela regios';
COMMENT ON COLUMN hr.regios.nome_regiao IS 'Nome da regiao Ex: amererica latina';


CREATE INDEX regios_idx
 ON hr.regios
 ( nome_regiao );

CREATE UNIQUE INDEX regios_idx1
 ON hr.regios
 ( nome_regiao );

CREATE TABLE hr.paises (
                id_pais INTEGER NOT NULL,
                nome_pais VARCHAR(50) NOT NULL,
                id_regiao CHAR(2) NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (id_pais),
				UNIQUE(nome_pais)
);
COMMENT ON COLUMN hr.paises.id_pais IS 'Chave primaria da tabale paises';
COMMENT ON COLUMN hr.paises.nome_pais IS 'Nome do pais Ex: Brasil';
COMMENT ON COLUMN hr.paises.id_regiao IS 'Chave estrangeira para a tabela regioes';


CREATE UNIQUE INDEX paises_idx
 ON hr.paises
 ( nome_pais );

CREATE TABLE hr.localizacao (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50) NOT NULL,
                uf VARCHAR(25),
                id_pais INTEGER NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON COLUMN hr.localizacao.id_localizacao IS 'Chave primaria da tabela Localização';
COMMENT ON COLUMN hr.localizacao.endereco IS 'Campo de endereço Ex: nome da rua';
COMMENT ON COLUMN hr.localizacao.cep IS 'Cep postal do endereço';
COMMENT ON COLUMN hr.localizacao.cidade IS 'Cidade no qual aquele endereço se encontra';
COMMENT ON COLUMN hr.localizacao.uf IS 'Sigla do estado em que o endereço se encontra';
COMMENT ON COLUMN hr.localizacao.id_pais IS 'Chave estrangera da tabela paises';


CREATE TABLE hr.departamentos (
                id_departamentos INTEGER NOT NULL,
                nome_departamento VARCHAR(30) NOT NULL,
                id_localizacao INTEGER NOT NULL,
                id_surpevisor INTEGER NOT NULL,
                CONSTRAINT id_departamentos PRIMARY KEY (id_departamentos),
				UNIQUE(nome_departamento)
);
COMMENT ON COLUMN hr.departamentos.id_departamentos IS 'Chave primaria da tabela departamentos';
COMMENT ON COLUMN hr.departamentos.nome_departamento IS 'Nome do departamento';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'chave estrangera da tabela localicao';
COMMENT ON COLUMN hr.departamentos.id_surpevisor IS 'Chave primaria da tabela empregados';


CREATE UNIQUE INDEX departamentos_idx
 ON hr.departamentos
 ( nome_departamento );

CREATE TABLE hr.empregados (
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
                CONSTRAINT id_empregados_ PRIMARY KEY (id_empregados),
				UNIQUE(nome_empregado, email)
);
COMMENT ON COLUMN hr.empregados.id_empregados IS 'Chave primaria da tabela empregados';
COMMENT ON COLUMN hr.empregados.nome_empregado IS 'Nome completo do empregado';
COMMENT ON COLUMN hr.empregados.email IS 'email do funcionario';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'Data de inicio do empregado na empresa';
COMMENT ON COLUMN hr.empregados.salario IS 'valor de salario que o funcionario recebe';
COMMENT ON COLUMN hr.empregados.comissao IS 'porcentagem da comissao do funcionario caso receba, somente o departamento de vendas e elegivel para comissao';
COMMENT ON COLUMN hr.empregados.telefone IS 'telefone de contato do funcionario';
COMMENT ON COLUMN hr.empregados.id_cargos IS 'Chave estrangera para a tabela de cargos';
COMMENT ON COLUMN hr.empregados.id_departamentos IS 'Chave primaria da tabela departamentos';


CREATE UNIQUE INDEX empregados_idx
 ON hr.empregados
 ( nome_empregado, email );

CREATE TABLE hr.historico_cargos (
                id_empregados INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_departamentos INTEGER NOT NULL,
                CONSTRAINT id_historico_cargos PRIMARY KEY (id_empregados, data_inicial)
);
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'Uma coluna não nula na chave primária complexa id_empregado+data_inicial.
Deve ser menor que a data_final da tabela historico_cargos.';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'ultimo dia do funcionário nesta função. Uma coluna não nula. Deve ser
maior que a data_inicial';


ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargos)
REFERENCES hr.cargos (id_cargos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.paises ADD CONSTRAINT regios_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regios (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.localizacao ADD CONSTRAINT paises_localizacao_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT localizacao_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacao (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamentos)
REFERENCES hr.departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamentos)
REFERENCES hr.departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregados)
REFERENCES hr.empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_surpevisor)
REFERENCES hr.empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;