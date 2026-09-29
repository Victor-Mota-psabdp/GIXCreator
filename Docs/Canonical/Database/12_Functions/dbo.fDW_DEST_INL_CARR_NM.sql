SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spINTSmartTransportadora_SEl]
--select  [dbo].[fDW_DEST_INL_CARR_NM]('')
CREATE Function [dbo].[fDW_DEST_INL_CARR_NM]
(
	@Num_Proc varchar(16)

)
RETURNS varchar(200)

BEGIN
	Declare @Resultado varchar(200)
			
		Begin
			If left(@Num_Proc,2)='IM'
				Begin
					SET @Resultado=(select nome_raz_soc from llp_imp_mar LLP with(nolock)
									Join Pessoa PP with(nolock) on pp.cd_pes=cd_transportadora	
									Join PEssoa_LLP PPL with(nolock) on PPL.cd_pes=cd_transportadora
									where LLP.num_proc_lim= @Num_Proc)
				End
			Else If left(@Num_Proc,2)='IA'
				Begin
					SET @Resultado=(select nome_raz_soc from llp_imp_aer LLP with(nolock)
									Join Pessoa PP with(nolock) on pp.cd_pes=cd_transportadora	
									Join PEssoa_LLP PPL with(nolock) on PPL.cd_pes=cd_transportadora
									where LLP.Num_Proc_Lia= @Num_Proc)
				End
			Else
				Begin
					SET @Resultado = NULL
				End
			
		End

	RETURN @Resultado

END















GO
