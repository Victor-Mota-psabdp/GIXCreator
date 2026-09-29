SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSolicitacao_Retificacao_JOB_Sel]
	@NUM_PROC varchar(16)
AS
select	
	DST.Nome_Local					[Port OF Discharge],
	P.Apelido						[Consignee],
	HOU.MAWB_HIM					[MBL],
	HOU.HAWB_HIM					[HBL]		
from LLP_IMP_Mar LLP
	join House_Imp_Mar HOU on HOU.Num_Proc_HIM = LLP.Num_Proc_Lim
	join Localidade DST on DST.Cd_Local = HOU.Cd_Dst_HIM
	join Pessoa P on Cd_Pes = HOU.Cd_Consig_HIM	
Where
	 LLP.Num_Proc_Lim = @NUM_PROC













GO
