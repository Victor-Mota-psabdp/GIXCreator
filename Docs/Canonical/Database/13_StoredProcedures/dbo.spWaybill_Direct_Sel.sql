SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spWaybill_Direct_Sel]
	
AS

select 
	HOU.Num_Proc Num_Proc_HEA,HOU.HAWB HAWB_HEA,E.Num_Proc_HEA_DT_Envio,HOU.MAWB,
	cia.Nome_Cia_Aer, HOU.Cd_Org,org.Nome_Local, HOU.Cd_Dst,dst.Nome_Local
from
	Exchange_E_AirFreight e
	left Join vwHouse_Exp HOU on E.Num_Proc_Hea = HOU.Num_Proc
	JOIN Cia_Aerea CIA on CIA.Cd_Cia_Aer = HOU.Cd_Armador
	JOIN LOcalidade ORG on ORG.Cd_Local = HOU.Cd_Org
	JOIN LOcalidade DST on DST.Cd_Local = HOU.CD_DST
where 
	--E.Num_Proc_Hea = 'EACSR20100600201'	
	--hou.Num_Proc_MEA = 'JOB'
	--and E.Num_Proc_MEA_DT_Envio is null 
	--and		
	E.Num_Proc_HEA_DT_Envio is null  
	and E.num_proc_hea_dt_ins > getdate() -31
	
	
	







--ALTER PROCEDURE [dbo].[spWaybill_Direct_Sel]
	
--AS

--select 
--	HOU.Num_Proc_HEA,HOU.HAWB_HEA,E.Num_Proc_HEA_DT_Envio 
--from
--	Exchange_E_AirFreight e
--	left Join house_exp_Aer HOU on E.Num_Proc_Hea = HOU.Num_Proc_HEA
--where 
--	--E.Num_Proc_Hea = 'EACSR20100600201'	
--	hou.Num_Proc_MEA = 'JOB'
--	--and E.Num_Proc_MEA_DT_Envio is null 
--	and	E.Num_Proc_HEA_DT_Envio is null  
	
	
	







GO
