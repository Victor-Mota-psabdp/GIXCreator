SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu 13/04/2023 - included [dbo].[FRemoveAcentuacao]
CREATE  Procedure [dbo].[spINTPlanta] 
	
		@num_proc	varchar(16)

as



select 
	[dbo].[FRemoveAcentuacao] (BU.cd_planta) Planta_Buyer, 
	[dbo].[FRemoveAcentuacao] (SL.cd_Planta) Planta_Seller, 
	PD.Planta Planta_Pedido 
from pedido_ship PS with(nolock)
Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
left jOIN Pessoa_LLP BU with(nolock) on BU.cd_pes=cd_buyer
Left Join Pessoa_LLP SL with(nolock) on SL.cd_pes=cd_seller
where num_proc=@num_proc
group by BU.cd_planta , SL.cd_Planta , PD.Planta  


--select 
--BU.cd_planta,
--[dbo].[FRemoveAcentuacao] (BU.cd_planta) ,
--[dbo].[FRemoveCaracteresEspeciais] (BU.cd_planta) ,
--[dbo].[FRemoveCaracteresEspeciais_EFreight] (BU.cd_planta) ,
--[dbo].[FRemoveCaracteresEspeciais_Enter] (BU.cd_planta) ,
--[dbo].[FRemoveCaracteresEspeciais_Schneider] (BU.cd_planta) ,
--[dbo].[FRemoveSpecial_chars] (BU.cd_planta) ,
--[dbo].[RemoveNonAlphaCharacters] (BU.cd_planta)
----[dbo].[RemoveNonAlphaCharacters] ([dbo].[FRemoveAcentuacao](BU.cd_planta))
--from pedido_ship PS with(nolock)
--Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
--left jOIN Pessoa_LLP BU with(nolock) on BU.cd_pes=cd_buyer
--Left Join Pessoa_LLP SL with(nolock) on SL.cd_pes=cd_seller
--where num_proc='IMSWB202302015BR'
--group by BU.cd_planta , SL.cd_Planta , PD.Planta  

GO
