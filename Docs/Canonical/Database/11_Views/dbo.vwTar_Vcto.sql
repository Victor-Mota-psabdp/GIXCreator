SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE    View vwTar_Vcto

as

select 
	'Aéreo' Modal, org.Nome_Local Origem, dst.Nome_Local Destino, Nome_Cia_Aer Nome_CIA, taedtval 
from 
	tar_aer TA
	Join Localidade DST on DST.cd_local=TAEcdDST
	Join Localidade ORG on ORG.cd_local=TAEcdORG
	Join Cia_aerea CIA on CIA.Cd_Cia_Aer=TA.cd_cia_Aer
Where 
	getdate()+3 >= taedtval and tptid=6


UNION

select 
	'MarItimo' Modal, org.Nome_Local Origem, dst.Nome_Local Destino, Nome_Armador Nome_CIA, taMdtval 
from 
	tar_mAr TA
	Join Localidade DST on DST.cd_local=TAmcdDST
	Join Localidade ORG on ORG.cd_local=TAmcdORG
	Join Armador CIA on CIA.Cd_armador=TA.cd_Armador
Where 
	getdate()+3 >= taMdtval  and tptid=6








GO
