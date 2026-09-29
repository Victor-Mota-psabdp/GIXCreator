SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure spBOPedidoPO_Sel --'40011558','00064646','01001SI'
	(
		@num_pedido varchar(30),
		@cd_vendor  varchar(20),
		@Cd_Planta	varchar(20)
	)
as

select  cd_pedido,num_pedido from pedido
Left Join Pessoa_LLP PP on PP.cd_pes=cd_buyer
Left Join Pessoa_LLP PE on PE.cd_pes=cd_seller
Where
	(PP.Cd_Vendor=@cd_vendor or PP.cd_planta=@cd_vendor) and(PE.CD_planta=@cd_planta or PE.CD_Vendor=@cd_planta)and Num_PO=@num_pedido





GO
