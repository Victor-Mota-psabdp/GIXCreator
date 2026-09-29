SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[spBOPedido_Sel]
	(
		@num_pedido varchar(30),
		@Cd_Planta	varchar(20)
	)
as

select  cd_pedido,num_pedido,cd_tipo from pedido
Left Join Pessoa_LLP PE on PE.cd_pes=cd_seller
Left Join Pessoa_LLP CS on CS.cd_pes=cd_buyer
Where
((PE.CD_planta=@cd_planta oR PE.CD_Vendor=@cd_planta)
or (CS.CD_planta=@cd_planta oR CS.CD_Vendor=@cd_planta))
and 
Num_Pedido=@num_pedido


/**
select  cd_pedido,num_pedido from pedido
Left Join Pessoa_LLP PP on PP.cd_pes=cd_buyer
Left Join Pessoa_LLP PE on PE.cd_pes=cd_seller
Where
	(PP.Cd_Vendor=@cd_vendor or PP.cd_planta=@cd_vendor) and(PE.CD_planta=@cd_planta oR PE.CD_Vendor=@cd_planta)and Num_Pedido=@num_pedido
**/







GO
