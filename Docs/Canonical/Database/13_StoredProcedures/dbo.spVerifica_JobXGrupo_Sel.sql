SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spVerifica_JobXGrupo_Sel]-- ''
(		
	@Grupo	as	varchar(60),
	@Job	as	varchar(16)
	)	
AS

select num_proc from vwClienteALLJOBS	V	
	Join Pessoa CLI with(nolock)  on V.cd_cliente=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on V.cd_cliente=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=PLLP.Cd_Pes_Grupo
where 
num_proc = @Job and PP.Apelido = @Grupo

	
GO
