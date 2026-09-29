SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spSoldTo]
		@num_proc	varchar(16)
as

select PS.cd_pedido,
	[dbo].[fBusca_Campo_Ordem](PS.cd_pedido,9) [Party-Name],
	[dbo].[fBusca_Campo_Ordem](PS.cd_pedido,10) [Party-Address],
	[dbo].[fBusca_Campo_Ordem](PS.cd_pedido,11) [Party-City],
	'' [Party-State-Prov],
	'' [Party-PostalCode],
	L.Cd_Pais [Party-Country],
	PS.cd_pedido [PartyLocation-ID],
	[dbo].[fBusca_Campo_Ordem](PS.cd_pedido,12) [Party-CountryName],
	L.Cd_Pais + L.Cd_Local [Party-UnlocCode]
from Pedido_Ship PS
	left join Campo_Ordem CP on CP.Cd_Pedido = PS.cd_pedido and Id_Campo = 11
	left join Localidade L on L.Nome_Local = CP.Campo_Dados
where Num_Proc = @num_proc
and cp.campo_dados is not null

--select * from Campo_Ordem where Cd_Pedido = 183506
--<Parties type="SoldTo">
--<Party-Name>SURTIQUIMICOS SA</Party-Name>
--<Party-Address>CARRERA OCTAVA # 127C - 31</Party-Address>
--<Party-City>BOGOTA</Party-City>
--<Party-State-Prov/>
--<Party-PostalCode/>
--<Party-Country>CO</Party-Country>
--<PartyLocation-ID>P000009062</PartyLocation-ID>
--<Party-CountryName>Colombia</Party-CountryName>
--<Party-UnlocCode>COBOG</Party-UnlocCode>
--<GovIDNumber/>
--</Parties> 


GO
