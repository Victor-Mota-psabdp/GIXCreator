SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Infineum_Sel]

As
	Select fatcod from fatura F
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=F.cd_pes
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	where 
		--fatcod ='IMIFB201308063BRB' and
		G.cd_pes_grupo = 'P21127' 
		and fatstatus=1 
		and fatdtvenc>=getdate() - 365
	order by fatcod
GO
