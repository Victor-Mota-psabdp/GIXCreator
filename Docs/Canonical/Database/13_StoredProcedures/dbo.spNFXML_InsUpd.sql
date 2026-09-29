SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNFXML_InsUpd]
		@Num_proc	varchar(16)

as

select BUYER.APELIDO Cliente,PL.cd_vendor from pedido_ship PS
Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Join Pessoa Buyer on Buyer.cd_pes=cd_buyer
Join Pessoa Seller on Seller.cd_pes=cd_seller
Join Pessoa_LLP PL on PL.cd_pes=cd_buyer
WHERE num_proc=@num_proc



GO
