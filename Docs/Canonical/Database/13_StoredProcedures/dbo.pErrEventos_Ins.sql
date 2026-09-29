SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pErrEventos_Ins 
(
@Arquivo_ERR			varchar(30),
@Cd_ERR			varchar(6),
@Campo_ERR			varchar(25),
@Chave_ERR			varchar(30),
@Viagem_ERR			varchar(10),
@BL_ERR			varchar(30),
@Porto_ERR			varchar(5),
@Armador_ERR			char(4),
@Emissao_ERR			datetime,
@Viagem_Age_ERR		varchar(10),
@Mensagem_ERR		varchar(100),
@Linha_ERR			int
)
AS
	Insert Into 
		Err_Eventos 
		(Arquivo_ERR, Cd_ERR, Campo_ERR, Chave_ERR, Viagem_ERR, BL_ERR, Porto_ERR, Armador_ERR, Emissao_ERR, Viagem_Age_ERR, Mensagem_ERR, Linha_ERR)
	Values 
		(@Arquivo_ERR, @Cd_ERR, @Campo_ERR, @Chave_ERR, @Viagem_ERR, @BL_ERR, @Porto_ERR, @Armador_ERR, @Emissao_ERR, @Viagem_Age_ERR, @Mensagem_ERR, @Linha_ERR)



GO
