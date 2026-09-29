SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure spCPGeraCtaCP_Sel
		
			@Customer		Varchar(50),
			@Origem			Varchar(30),
			@Destino		Varchar(30),
			@IntPrioridade	INT

AS

Begin
	
	if @IntPrioridade=0 
		Begin
			Select * from customer_profile CP
			Join Customer_Profile_Taxas CPT on CPT.id_CP=CP.id_Cp
			Join Pessoa PP on PP.cd_pes=Cd_Cliente
			Join Localidade org on org.cd_local=cd_org
			Join Localidade dst on dst.cd_local=cd_dst
			Join Tipo_taxa TT on TT.cd_tp_tx=CPT.cd_tp_Tx
			Left Join Tipo_Range_CP TRC on TRC.cd_range=Cd_Range_Compra
			Left Join Tipo_Range_CP TRV on TRV.cd_range=Cd_Range_Compra



		End

END
GO
