SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFatura_Consolidada_ClienteporGrupo_Sel]--'GRUPO OXITENO'
(
@Apelido		varchar(20)
)

AS

select  PL.apelido Apelido from pessoa P
	join Pessoa_LLP PLLP with(nolock) on PLLP.cd_pes_grupo = P.cd_pes
	left join pessoa PL on PL.cd_pes = PLLP.cd_pes
	where P.apelido= @Apelido
order by 1

--select apelido,* from Pessoa_LLP PL 
--	join pessoa P on P.cd_pes = PL.cd_pes
--	where cd_pes_grupo = 'P21128' order by 1





GO
