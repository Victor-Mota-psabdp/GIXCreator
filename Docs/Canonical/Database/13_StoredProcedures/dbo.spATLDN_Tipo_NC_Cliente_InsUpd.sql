SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_NC_Cliente
CREATE PROCEDURE [dbo].[spATLDN_Tipo_NC_Cliente_InsUpd]
(
	@Cd_NC				varChar(40),
	@Cd_Pes_Grupo		varChar(10),
	@Descricao_nC		varChar(150),
	@Parte_Resp			VarChar(50),
	@Processo			VarChar(50),
	@Descricao_NC_ENG	VarChar(1000),
	@Descricao_NC_PTG	VarChar(1000),
	@Ativo				Char,
	@Historico_Padrao	varChar(300),
	@Ativo_Historico	Bit
	
)
AS

Begin Transaction

	If  exists (select Cd_NC from Tipo_NC_Cliente where Cd_NC=@Cd_NC AND Cd_Pes_Grupo = @Cd_Pes_Grupo)
	Begin
		Update
			Tipo_NC_Cliente
		Set
			Descricao_nC=@Descricao_nC,
			Parte_Resp = @Parte_Resp,
			Processo = @Processo,
			Descricao_NC_ENG = @Descricao_NC_ENG,
			Descricao_NC_PTG = @Descricao_NC_PTG,
			ativo = @ativo,
			Historico_Padrao = @Historico_Padrao,
			Ativo_Historico = @Ativo_Historico
		Where
			Cd_NC=@Cd_NC AND Cd_Pes_Grupo = @Cd_Pes_Grupo
	End
	Else
		Insert
			Tipo_NC_Cliente(Cd_NC,Cd_Pes_Grupo,Descricao_nC,Parte_Resp,Processo,Descricao_NC_ENG,Descricao_NC_PTG,ativo,
			Historico_Padrao,Ativo_Historico)
		Values
			(@Cd_NC,@Cd_Pes_Grupo,@Descricao_nC,@Parte_Resp,@Processo,@Descricao_NC_ENG,@Descricao_NC_PTG,@ativo,
			@Historico_Padrao,@Ativo_Historico)
	

Commit Transaction

GO
