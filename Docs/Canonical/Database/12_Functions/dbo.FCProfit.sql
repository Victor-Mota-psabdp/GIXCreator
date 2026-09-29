SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function FCProfit(
				@Processo varchar(16)

)
RETURNS float
BEGIN
		Declare @PesoTotal Float
		Declare @PesoHouse Float
		Declare @DespMaster Float
		Declare @ReceiHouse Float
		Declare @Resultado  Float
	Set @PesoTotal=(select sum(peso_tax) Peso from house_exp_aer where num_proc_mea=left(@processo,14))
	Set @PesoHouse=(select sum(peso_tax) Peso from house_exp_aer where num_proc_hea=@processo)
	Set @DespMaster=(select sum(dbo.valor(vlr_org_mea,dc_mea)) Valor from cta_Cte_mas_exp_aer where num_proc_mea=left(@processo,14) and Comp_CPA_MEA='S')	
	Set @ReceiHouse	=(select sum(dbo.valor(vlr_org_hea,dc_hea)) Valor from cta_Cte_hou_exp_aer where num_proc_hea=@processo and Comp_CPA_hEA='S')	
	Set @Resultado=@DespMaster*(@PesoHouse/@PesoTotal)+@Receihouse

RETURN @Resultado

END



GO
