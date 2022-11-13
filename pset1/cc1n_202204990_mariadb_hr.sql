
CREATE TABLE cargos (
                id_cargos VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_maximo DECIMAL(8,2),
                salario_minimo DECIMAL(8,2),
                PRIMARY KEY (id_cargos)
);


CREATE TABLE regios (
                id_regiao CHAR(2) NOT NULL,
                nome_regiao VARCHAR(25) DEFAULT AK NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regios COMMENT 'Tabela que guardara o dados dos nomes das regioes';

ALTER TABLE regios MODIFY COLUMN id_regiao CHAR(2) COMMENT 'Chave primaria da tabela regios 
';

ALTER TABLE regios MODIFY COLUMN nome_regiao VARCHAR(25) COMMENT 'Nome da regiao Ex: amererica latina';


CREATE INDEX regios_idx
 ON regios
 ( nome_regiao );

CREATE TABLE paises (
                id_pais INT NOT NULL,
                nome_pais VARCHAR(50) NOT NULL,
                id_regiao CHAR NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises MODIFY COLUMN id_pais INTEGER COMMENT 'Chave primaria da tabale paises ';

ALTER TABLE paises MODIFY COLUMN nome_pais VARCHAR(50) COMMENT 'Nome do pais Ex: Brasil ';

ALTER TABLE paises MODIFY COLUMN id_regiao CHAR COMMENT 'Chave estrangeira para a tabela regioes ';


CREATE TABLE localizacao (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50) NOT NULL,
                uf VARCHAR(25),
                id_pais INT NOT NULL,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacao MODIFY COLUMN id_localizacao INTEGER COMMENT 'Chave primaria da tabela Localização';

ALTER TABLE localizacao MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Campo de endereço Ex: nome da rua ';

ALTER TABLE localizacao MODIFY COLUMN cep VARCHAR(12) COMMENT 'Cep postal do endereço ';

ALTER TABLE localizacao MODIFY COLUMN cidade VARCHAR(50) COMMENT 'Cidade no qual aquele endereço se encontra ';

ALTER TABLE localizacao MODIFY COLUMN uf VARCHAR(25) COMMENT 'Sigla do estado em que o endereço se encontra ';

ALTER TABLE localizacao MODIFY COLUMN id_pais INTEGER COMMENT 'Chave estrangera da tabela paises ';


CREATE TABLE departamentos (
                id_departamentos INT NOT NULL,
                nome_departamento VARCHAR(30) NOT NULL,
                id_localizacao INT NOT NULL,
                id_surpevisor INT NOT NULL,
                PRIMARY KEY (id_departamentos)
);

ALTER TABLE departamentos MODIFY COLUMN id_departamentos INTEGER COMMENT 'Chave primaria da tabela departamentos ';

ALTER TABLE departamentos MODIFY COLUMN nome_departamento VARCHAR(30) COMMENT 'Nome do departamento ';

ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'chave estrangera da tabela localicao ';

ALTER TABLE departamentos MODIFY COLUMN id_surpevisor INTEGER COMMENT 'Chave primaria da tabela empregados ';


CREATE TABLE empregados (
                id_empregados INT NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                data_contratacao DATE NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                telefone VARCHAR(20),
                id_cargos VARCHAR(10) NOT NULL,
                id_supervisor INT NOT NULL,
                id_departamentos INT NOT NULL,
                PRIMARY KEY (id_empregados)
);

ALTER TABLE empregados MODIFY COLUMN id_empregados INTEGER COMMENT 'Chave primaria da tabela empregados ';

ALTER TABLE empregados MODIFY COLUMN nome_empregado VARCHAR(75) COMMENT 'Nome completo do empregado 
';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'email do funcionario';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Data de inicio do empregado na empresa ';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'valor de salario que o funcionario recebe';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'porcentagem da comissao do funcionario caso receba, somente o departamento de vendas e elegivel para comissao';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'telefone de contato do funcionario';

ALTER TABLE empregados MODIFY COLUMN id_cargos VARCHAR(10) COMMENT 'Chave estrangera para a tabela de cargos ';

ALTER TABLE empregados MODIFY COLUMN id_departamentos INTEGER COMMENT 'Chave primaria da tabela departamentos ';


CREATE TABLE historico_cargos (
                id_empregados INT NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_departamentos INT NOT NULL,
                PRIMARY KEY (id_empregados, data_inicial)
);

ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'Uma coluna não nula na chave primária complexa id_empregado+data_inicial.
Deve ser menor que a data_final da tabela historico_cargos.';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'ultimo dia do funcionário nesta função. Uma coluna não nula. Deve ser
maior que a data_inicial';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargos)
REFERENCES cargos (id_cargos)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE paises ADD CONSTRAINT regios_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regios (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacao ADD CONSTRAINT paises_localizacao_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT localizacao_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacao (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamentos)
REFERENCES departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamentos)
REFERENCES departamentos (id_departamentos)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregados)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_surpevisor)
REFERENCES empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
