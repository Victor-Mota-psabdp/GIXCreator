SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spTarVenc_Rel 
		(
			@Data varchar(10)
		)
AS	 
select 
	'Aéreo' Modal,org.Nome_Local Origem, dst.Nome_Local Destino, TAEdtVal Data,nome_cia_Aer 
from 
	tar_aer TAR
	Join Localidade Org on Org.cd_local=TAEcdORG
	Join Localidade Dst on Dst.cd_local=TAEcdDST
	Join Cia_Aerea CIA on Cia.cd_cia_aer=TAR.cd_cia_aer
where tptid=6 and taedtval < @data 


UNION

select 
	'Marítimo' Modal,org.Nome_Local Origem, dst.Nome_Local Destino, TAMdtVal Data,nome_armador
from 
	tar_Mar TAR
	Join Localidade Org on Org.cd_local=TAMcdORG
	Join Localidade Dst on Dst.cd_local=TAMcdDST
	Join Cia_armador CIA on Cia.cd_armador=TAR.cd_armador
where tptid=6 and taMdtval < @data 



GO
