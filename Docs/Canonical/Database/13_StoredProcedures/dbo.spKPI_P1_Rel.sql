SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spKPI_P1_Rel

	@datafinal	varchar(10)

AS

select 
	org.nome_local Origem,dst.nome_local Destino,
	month(convert(datetime,dt_pia,105)) Mes, 
	year(convert(datetime,dt_pia,105)) Ano, avg(Trf_Cp_1_TNIA) Minima,
	Avg(Trf_Cp_2_TNIA) K45,avg(Trf_Cp_3_TNIA) K100,avg(Trf_Cp_4_TNIA) K300,
	avg(Trf_Cp_5_TNIA) K500,avg(Trf_Cp_6_TNIA) K1000, avg(Trf_Cp_7_TNIA) K2000, avg(Trf_Cp_8_TNIA) Mais2000

from tarifa_neg_imp_aer TF

	inner join Proposta_Imp_AER prop on prop.num_prop_ia=tf.num_prop_ia
	inner join localidade org on org.cd_local=cd_org_Tnia
	inner join localidade dst on dst.cd_local=cd_dst_tnia

where 	(convert(datetime,dt_pia,105))>=convert(datetime,@datafinal,105)-90
	and org.pais_local = 'EUA'

group by

	org.nome_local,dst.nome_local, month(convert(datetime,dt_pia,105)) , 
	year(convert(datetime,dt_pia,105)) 

GO
