SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHouseWaybill_Sel]
	
AS

select distinct
	HOU.Num_Proc_HEA, MEA.Num_Proc_MEA,HOU.MAWB_HEA,HOU.HAWB_HEA, C.Nome_Cia_Aer	
from 
	Master_Exp_Aer MEA
	Join house_exp_Aer HOU on MEA.num_proc_mea = HOU.num_proc_mea
	join Volume_Exp_Aer V on V.Num_Proc_HEA = Hou.Num_Proc_HEA
	--Join llp_exp_Aer LL on HOU.Num_Proc_HEA = LL.Num_Proc_Lea
	join Cia_Aerea C on C.Cd_Cia_Aer = MEA.Cd_Cia_Aer
	Join Exchange_E_AirFreight LL on MEA.Num_Proc_MEA = LL.Num_Proc_MEA	
Where
	LL.Num_Proc_MEA_DT_Envio is not null and
	LL.Num_Proc_HEA_DT_Envio is null and
	Dt_Impres_MEA is not null
	--Piece,Volume,Weight
	and Convert(decimal(18,2),Peso_Bruto_MEA)	> 0
	and convert(decimal(18,2),MEA.Vol_Tot_MEA)	> 0
	and convert(decimal(18,2),mEA.Peso_Bruto_MEA)> 0
	and convert(int,Qtd_Tot_Vol_MEA)> 0
	--and	
	--MEA.Num_Proc_mea in
	--(
	--	'EAGRU201511019'
	--)

	--MEA.Num_Proc_mea in ('EAGRU201601006','EAGRU201511019')
	--MEA.Num_Proc_mea in ('EAGRU201502001','EAVCP201506001')
	--MEA.Num_Proc_mea in ('EAGRU201502018','EAGIG201508001')	
	--MEA.Num_Proc_mea in ('EAVCP201506001')
	--MEA.Num_Proc_mea in ('EAVCP201506001','EAGIG201503001','EAGRU201507015')
	--MEA.Num_Proc_MEA in ('EAGIG201408002','EAGRU201405015','EAGRU201411008','EAGRU201502009')
	--MEA.Num_Proc_mea in ('EAGRU201502001')







	--MEA.Num_Proc_mea in ('EAGRU201502009')
	--MEA.Num_Proc_mea in ('EAGRU201502001')
	--MEA.Num_Proc_mea in ('EAVCP201507002','EAVCP201507003','EAGRU201502009')
	--MEA.Num_Proc_mea in ('EAVCP201507002','EAVCP201507003')		
	--MEA.Num_Proc_mea in 
	--('EAGRU201512001','EAPOA201511004','EAGRU201411008','EAGIG201408002','EAGRU201405015',
	--'EAGIG201503001','EAGRU201501009','EAGRU201502001','EAGRU201502009','EAVCP201506002',
	--'EAVCP201506003','EAVCP201506004')
	
	







GO
