SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spNFDet_Sel] '192709','DOW BRASIL S 0663279'
CREATE    	 Procedure [dbo].[spNFDet_Sel] 
				
				@ID_NF		int,
				@Cliente	Varchar(50)
				--@Pedido		Varchar(10),
				--@Produto	Varchar(10),
				--@Modal		char(1)

AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
--	Declare @Cd_Pedido	int
--	Declare	@Cd_Produto	int

	Set @Cd_Cliente = (Select Cd_Pes from Pessoa where apelido = @Cliente)
	--Set @Cd_Pedido = (select Cd_Pedido from Pedido  where Num_Pedido=@Pedido and cd_modal=@Modal and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE))
	--Set @Cd_Produto = (select Cd_Prod from produto_cliente where cd_proc_Cliente=@Produto and cd_cliente=@cd_cliente) 
 
		Select distinct
				NF.ID_Item,
				PC.Cd_Proc_Cliente,
				PC.Produto_Descr,
				PD.Num_Pedido,
				NCM,	
				Quantidade,
				Vlr_Item,
				Vlr_Total_Item,
				Vlr_Frete,
				Vlr_Seguro,
				Vlr_Outras_Despesas,
				ALIQ_II,
				VL_II,
				ALIQ_IPI,
				VL_BASE_IPI,
				VL_TRIBUTAVEL_IPI,
				VL_IPI,
				VL_ALIQ_PIS,
				VL_BASE_PIS,
				VL_IMPOSTO_PIS,
				VL_ALIQ_COFINS,
				VL_BASE_COFINS,
				VL_IMPOSTO_COFINS,
				ALIQ_ICMS,
				VL_BASE_ICMS,
				VL_ICMS,
				VL_TRIBUTAVEL_ICMS,
				Vlr_Total_NF,
				Peso_Bruto,
				Peso_Liquido,
				Acrescimos
		from
				Nota_Fiscal_Cliente_Det NF With(nolock)
		
		Left Outer Join Pedido_Ship		PDS With(nolock)	on NF.Cd_Pedido = PDS.Cd_Pedido
		Left Outer Join Pedido			PD	With(nolock)	on PDS.Cd_Pedido = PD.Cd_Pedido
		Left Outer Join Produto_Cliente PC 	With(nolock)	on NF.Cd_Produto =PC.Cd_prod 
		Left Outer Join Pessoa			PS	With(nolock)	on @Cd_Cliente = PS.cd_pes
		where
				ID_NF= @ID_NF and NF.Cd_Cliente = @Cd_Cliente
		--group by 
		--		PC.Cd_Proc_Cliente,
		--		PC.Produto_Descr,
		--		PD.Num_Pedido,
		--		NCM,	
		--		Quantidade,
		--		Vlr_Item,
		--		Vlr_Total_Item,
		--		Vlr_Frete,
		--		Vlr_Seguro,
		--		Vlr_Outras_Despesas,
		--		ALIQ_II,
		--		VL_II,
		--		ALIQ_IPI,
		--		VL_BASE_IPI,
		--		VL_TRIBUTAVEL_IPI,
		--		VL_IPI,
		--		VL_ALIQ_PIS,
		--		VL_BASE_PIS,
		--		VL_IMPOSTO_PIS,
		--		VL_ALIQ_COFINS,
		--		VL_BASE_COFINS,
		--		VL_IMPOSTO_COFINS,
		--		ALIQ_ICMS,
		--		VL_BASE_ICMS,
		--		VL_ICMS,
		--		VL_TRIBUTAVEL_ICMS,
		--		Vlr_Total_NF,
		--		Peso_Bruto,
		--		Peso_Liquido,
		--		Acrescimos

		

Commit Transaction 










GO
