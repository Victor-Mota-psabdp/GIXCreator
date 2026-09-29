SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_CampoClienteDeliveryName]
(
	@cd_pedido int
)
RETURNS Varchar(1000) 
AS
BEGIN
		declare @Resultado as varchar(400)

		--set @Resultado = (select 'Nome: ' + CP4.Campo_Dados + ' Rua: ' + CP5.Campo_Dados +	' Cidade: ' + CP7.Campo_Dados 
		--					+ '/' + CP6.Campo_Dados +	' CEP:' + CP8.Campo_Dados 
		--				from pedido P
		--					left join Campo_Ordem CP4 on CP4.cd_pedido = P.Cd_pedido and CP4.Id_Campo  = 4
		--					left join Campo_Ordem CP5 on CP5.cd_pedido = P.Cd_pedido and CP5.Id_Campo  = 5
		--					left join Campo_Ordem CP6 on CP6.cd_pedido = P.Cd_pedido and CP6.Id_Campo  = 6
		--					left join Campo_Ordem CP7 on CP7.cd_pedido = P.Cd_pedido and CP7.Id_Campo  = 7
		--					left join Campo_Ordem CP8 on CP8.cd_pedido = P.Cd_pedido and CP8.Id_Campo  = 8
		--				Where
		--					P.Cd_pedido = @cd_pedido)
							
		set @Resultado = (select 'Nome: ' + isnull(CP4.Campo_Dados,'')
								+	' Rua: ' + isnull(CP5.Campo_Dados,'') 
								+	' Cidade: ' + isnull(CP18.Campo_Dados,'') 
								+	' Estado: ' + isnull(CP7.Campo_Dados,'') 
								+	'/' + isnull(CP6.Campo_Dados,'') 
								+	' CEP:' + isnull(CP8.Campo_Dados ,'')
						from pedido P
							join Campo_Ordem CP4 on CP4.cd_pedido = P.Cd_pedido and CP4.Id_Campo  = 4
							join Campo_Ordem CP5 on CP5.cd_pedido = P.Cd_pedido and CP5.Id_Campo  = 5
							left join Campo_Ordem CP6 on CP6.cd_pedido = P.Cd_pedido and CP6.Id_Campo  = 6
							left join Campo_Ordem CP7 on CP7.cd_pedido = P.Cd_pedido and CP7.Id_Campo  = 7
							left join Campo_Ordem CP8 on CP8.cd_pedido = P.Cd_pedido and CP8.Id_Campo  = 8
							left join Campo_Ordem CP18 on CP18.cd_pedido = P.Cd_pedido and CP18.Id_Campo  = 18
							--18 - Delivery Location
						Where
							P.Cd_pedido = @cd_pedido and CP4.Campo_Dados is not null)

		RETURN @Resultado
END









GO
