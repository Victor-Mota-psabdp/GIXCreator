SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--04-06-2008
--Week 23
--Alteração - Claudio

--10-06-2008
--Week 24
--Alteração FOB DAS - Helio - Claudio

--18-10
--incluido do DAS as referencia, item e lote
--Carlos Eduardo

CREATE  function [dbo].[FBusca_FOB](
			@Num_Proc Varchar(16),
			@Tipo char(1)
			
		)returns Float
AS 




BEGIN
	Declare @Valor Float
	if @Tipo='W' -- Walmart, Adicionado por Anderson em 07/01/2010
		Begin
			Set @Valor=isnull((select sum(vlr_pedido) from pedido with(nolock) where cd_pedido in (select distinct cd_pedido from pedido_ship with(nolock) where num_proc=@num_proc)),0)
		End
	

	if @Tipo='I'
		BEGIN
			set @valor=Isnull((
				select sum(vlr_Item * PD.Qty) from Pedido_Det PD with(nolock)
				Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto
				Where num_proc=@num_proc 
				),0)
		END

	if @Tipo='D' --DAS
		BEGIN
			set @valor=Isnull((
				select sum(vlr_Total_Item) from Pedido_Det PD with(nolock)
				Join Pedido_Ship PS with(nolock) on PS.cd_pedido=PD.cd_pedido and PS.cd_produto=PD.cd_produto and PS.item = PD.item and PS.lote = PD.lote
				Where num_proc=@num_proc 
				),0)
		END

	If @tipo='S'
		BEGIN
			set @valor=Isnull((
				select sum(vlr_Seguro) from Nota_fiscal_cliente_det NFDET with(nolock)
				Join Nota_Cliente NC with(nolock) on NC.Id_NF=NFDET.ID_NF and NC.Cd_Cliente=NFDET.Cd_Cliente
				Where num_proc=@num_proc 
				),0)
		END





		return @Valor
END






GO
