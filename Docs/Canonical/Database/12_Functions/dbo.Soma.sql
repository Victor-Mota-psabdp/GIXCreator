SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE    function Soma(
			@RM as Varchar(20)

)

RETURNS float
BEGIN
		Declare @Saida float


Set @Saida=IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_hia,dc_hia)) Soma from caixa_hou_imp_aer where num_rcb_hia=@RM
),0.00)

Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_hea,dc_hea)) Soma from caixa_hou_exp_aer where num_rcb_hea=@RM
),0.00)

Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_him,dc_him)) Soma from caixa_hou_imp_mar where num_rcb_him=@RM
),0.00)

Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_hem,dc_hem)) Soma from caixa_hou_exp_mar where num_rcb_hem=@RM
),0.00)
   	
Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_mea,dc_mea)) Soma from caixa_mas_exp_aer where num_rcb_mea=@RM
),0.00)


Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_mia,dc_mia)) Soma from caixa_mas_imp_aer where num_rcb_mia=@RM
),0.00)

Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_mim,dc_mim)) Soma from caixa_mas_imp_mar where num_rcb_mim=@RM
),0.00)

Set @Saida=@Saida+IsNull(
		
		(select sum(dbo.valor(vlr_pgto_Rcto_mem,dc_mem)) Soma from caixa_mas_exp_mar where num_rcb_mem=@RM
),0.00)


Return @Saida

ENd












GO
