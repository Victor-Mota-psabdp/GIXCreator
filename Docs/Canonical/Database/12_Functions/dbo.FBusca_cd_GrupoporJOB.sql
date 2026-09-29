SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FBusca_cd_GrupoporJOB]
(
	@processo varchar(16)
)
RETURNS varchar(50)
AS
BEGIN
	
	Declare @resultado varchar(50)
	set @resultado = (select PP.Cd_Pes from vwClienteALLJOBS	V	
		Join Pessoa CLI with(nolock)  on V.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on V.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=PLLP.Cd_Pes_Grupo
	where 
		num_proc = @processo)
	
	
	RETURN @resultado

END

GO
