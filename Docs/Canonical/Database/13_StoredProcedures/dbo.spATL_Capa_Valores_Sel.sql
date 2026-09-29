SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--antonio 09-08-2024 
CREATE procedure [dbo].[spATL_Capa_Valores_Sel]
(
	@Num_Proc			Varchar(16),
	@Tipo				char(1)
)
as

if @Tipo = 'A' 
	Begin	
		select 
			ACV.Num_Proc				    	[JOB],
			ACV.FOB_USD                         [FOB USD],
			ACV.CIF_USD                         [CIF USD], 
			ACV.FRETE_USD                       [FRETE USD], 
			ACV.FOB_REAIS                       [FOB REAIS],  
			ACV.ACRESCIMOS_REAIS                [ACRESCIMOS REAIS],
			ACV.SEGURO_REAIS                    [SEGURO REAIS],
			ACV.FRETE_REAIS                     [FRETE REAIS], 
			TMF.Nome_Tp_Moeda                   [Currency Name Frete],
			ACV.Cd_Tp_Moeda_Frete               [Currency Code Frete], 
			CFR.Nome_Tp_Moeda                   [Currency Name CFR],
			ACV.Cd_Tp_Moeda_CFR                 [Currency Code CFR],
			ACV.CIF_REAIS                       [CIF REAIS]
		from ATL_Capa_Valores acv with(nolock)
			 Join Tipo_Moeda TMF on TMF.Cod_Nac_Moeda=acv.Cd_Tp_Moeda_Frete
			 Join Tipo_Moeda CFR on CFR.Cod_Nac_Moeda=acv.Cd_Tp_Moeda_CFR
		where
			acv.Num_Proc = @Num_Proc
	End

GO
