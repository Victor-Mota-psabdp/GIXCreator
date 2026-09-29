SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spBuscaNumOrderTemp_Sel] 'Order OxitenoEXP'


--select * from Pedido_Temp where dt_insert > '2014-08-01'


CREATE procedure [dbo].[spBuscaNumOrderTemp_Sel] (
	@Nome_Tp_Int varchar(50)

)
as

select Cd_pedido from Pedido_Temp PT
join Tipo_Integracao TI on PT.ID_Tp_Int = TI.ID_Tp_Int
where Dt_Leitura is null 
and  TI.Nome_Tp_Int = @Nome_Tp_Int
and Erro is null
--and cd_pedido <> 113
--and dt_Insert > getdate() - 30
--and Vlr_Total_Item < '8581692463'
--and  Num_pedido not in ('724154')




GO
