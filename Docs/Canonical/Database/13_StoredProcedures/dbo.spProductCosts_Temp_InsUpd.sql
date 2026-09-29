SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spProductCosts_Temp_InsUpd]

	 @Cd_Produto int,
	 @ALIQ_II float ,
	 @ALIQ_IPI float,
	 @VL_ALIQ_PIS float ,
	 @VL_ALIQ_COFINS float,
	 @ALIQ_ICMS float,
	 @Emissao Datetime,
	 @ID_NF int

AS

Begin Transaction

	if  exists (select cd_produto from ProductCosts_Temp where Cd_Produto=@Cd_Produto)
		Begin
			Update
				ProductCosts_Temp
			Set
				 ALIQ_II  = @ALIQ_II,
				 ALIQ_IPI  = @ALIQ_IPI,
				 VL_ALIQ_PIS  = @VL_ALIQ_PIS,
				 VL_ALIQ_COFINS  = @VL_ALIQ_COFINS,
				 ALIQ_ICMS  = @ALIQ_ICMS,
				 Emissao  = @Emissao,
				 ID_NF  =  @ID_NF
			Where
				Cd_Produto=@Cd_Produto
		End
	Else
		Insert
			ProductCosts_Temp(Cd_Produto,ALIQ_II,ALIQ_IPI, VL_ALIQ_PIS,VL_ALIQ_COFINS,ALIQ_ICMS,Emissao,ID_NF)
		Values
			(@Cd_Produto ,@ALIQ_II,@ALIQ_IPI ,@VL_ALIQ_PIS,@VL_ALIQ_COFINS,@ALIQ_ICMS,@Emissao,@ID_NF)	

Commit Transaction






GO
