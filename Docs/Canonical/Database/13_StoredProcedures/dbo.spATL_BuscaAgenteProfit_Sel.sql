SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_BuscaAgenteProfit_Sel]
(
	@Num_Proc as varchar(16),
	@Nome_Tp_Tx as varchar(50)
)
as

if exists(Select Nome_Tp_Tx from Tipo_Taxa  with(nolock) where Nome_Tp_Tx = @Nome_Tp_Tx and CD_AX_Resultado = '324.2') 
	Begin
		Select AG.Apelido Agente from vwCliente CL with(nolock)
		join  Master_Imp_Aer MAS with(nolock) on CL.Master = MAS.Num_Proc_MIA
		join Pessoa AG  with(nolock) on MAS.Cd_Export_MIA = AG.Cd_Pes
		where CL.num_proc = @Num_Proc and CL.Master <>'JOB'
		UNION
		Select AG.Apelido Agente from vwCliente CL with(nolock)
		join  Master_Imp_mar MAS with(nolock) on CL.Master = MAS.Num_Proc_MIM
		join Pessoa AG  with(nolock) on MAS.Cd_Export_MIM = AG.Cd_Pes
		where CL.num_proc = @Num_Proc and CL.Master <>'JOB'
	End
else
	Begin
		Select NULL Agente
	End
GO
