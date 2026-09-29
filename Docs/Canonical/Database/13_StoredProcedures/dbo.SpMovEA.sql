SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SpMovEA

		@datainicial 	varchar(10),
		@datafinal	varchar(10),
		@de		varchar(25),
		@para		varchar(25)

AS


select 

	mawb_mea, convert(datetime, dt_saida_mea, 105) as Data, nome_cia_aer, Peso_Bruto_mea, 
	cd_tp_moeda, cast(vlr_frete_mea as smallmoney) as Valor, origem.nome_local as OrigemL, 
	destino.nome_local as DestinoL 

from 

	master_exp_aer
	inner join cia_aerea on (master_exp_aer.cd_cia_aer=cia_aerea.cd_cia_aer)
	inner join localidade as Origem on (origem.cd_local=cd_org_mea)
	inner join localidade as Destino on (destino.cd_local=cd_dst_mea)

where 

	convert(datetime, dt_saida_mea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	and destino.nome_local like @de and origem.nome_local like @para



GO
