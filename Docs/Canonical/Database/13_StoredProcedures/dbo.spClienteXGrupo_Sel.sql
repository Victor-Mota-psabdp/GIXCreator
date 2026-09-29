SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spClienteXGrupo_Sel]--'GRUPO Oxiteno'
(		
	@Grupo	as	varchar(60)
	)	
AS

Select 'ALL Clients' Apelido
union all
select PP.Apelido from Grupo G
	join Pessoa P on P.Cd_Pes = G.Cd_Pes_Grupo
	Join Pessoa_LLP PLLP with(nolock)  on G.Cd_Pes_Grupo=PLLP.Cd_Pes_Grupo
	join Pessoa PP with(nolock)  on PP.cd_pes=PLLP.Cd_Pes
where 
	P.Desat_Pes= 'N' and P.Apelido = @Grupo
	
	






GO
