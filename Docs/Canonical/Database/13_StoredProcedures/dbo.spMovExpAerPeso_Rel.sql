SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spMovExpAerPeso_Rel 
		@DataInicial Varchar(10),
		@DataFinal   Varchar(10)

as

select 
	year(convert(datetime,dt_saida_mea,105)) Ano, Nome_cia_aer,org.nome_local Origem, 
	Dst.Nome_Local Destino,nome_regiao , sum(Peso_Bruto_MEA) Peso
from 
	master_exp_aer MAS
	left Join CiA_aerea CIA on mas.cd_cia_aer=Cia.cd_cia_aer
	Join Localidade Org on Org.cd_local=cd_org_mea
	Join Localidade Dst on Dst.cd_local=cd_dst_mea
	join Regiao RG on RG.cd_regiao=dst.cd_regiao
	
Where 
	convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal
GROUP BY 
	year(convert(datetime,dt_saida_mea,105)), Nome_Cia_Aer,org.nome_local , Dst.Nome_Local ,nome_regiao





GO
