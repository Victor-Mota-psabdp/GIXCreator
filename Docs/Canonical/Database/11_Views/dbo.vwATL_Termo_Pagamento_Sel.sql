SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Campo_Cliente where Tab_Relacionada = 'Termo_Pagamento'
--select * from Tipo_Campo_Cliente where Tab_Relacionada = 'vwATL_Termo_Pagamento_Sel'
--update Tipo_Campo_Cliente set Tab_Relacionada = 'vwATL_Termo_Pagamento_Sel' where Tab_Relacionada = 'Termo_Pagamento'
--SELECT * FROM Termo_Pagamento
--criada paa ser usada no Tipo_Campo_Cliente, para nao trazer termos inativo
CREATE VIEW [dbo].[vwATL_Termo_Pagamento_Sel]
AS
select Cd_Termo, Descricao_Termo		
		from Termo_Pagamento T with(nolock)
		WHERE T.Ativo = 1
	
             
                       











GO
