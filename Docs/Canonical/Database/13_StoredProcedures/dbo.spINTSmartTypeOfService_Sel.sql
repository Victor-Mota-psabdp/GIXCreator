SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*"Function CodesNames(
Quando for FREIGHT FORWARD, vai enviar: CodesNamesType=BDP NORMAL e o CodesNamesType=1 e CodesNamesCode = 1
Quando for CHB, vai enviar: CodesNamesType=CUSTOM HOUSE BROKERAGE e o CodesNamesType=2 e CodesNamesCode = 2
Quando for CHB+FREIGHT FORWARD, vai enviar: CodesNamesType=BDP NORMAL WITH CHB e o CodesNamesType=6 e CodesNamesCode = 6"
*/

CREATE  procedure [dbo].[spINTSmartTypeOfService_Sel]
		@num_Proc Varchar(16)

AS

select (case when cp.Campo_Dados = '2' then 'BDP NORMAL' 
else (case when cp.Campo_Dados = '1' then 'CUSTOM HOUSE BROKERAGE'
else (case when cp.Campo_Dados = '3' then 'BDP NORMAL WITH CHB' else null
end)end)end) CodesNamesType,

(case when cp.Campo_Dados = '2' then '1' 
else (case when cp.Campo_Dados = '1' then '2'
else (case when cp.Campo_Dados = '3' then '6' else null
end)end)end) CodesNamesCode

from Campo_Processo cp 
join BDP_Produto bp on cp.Campo_Dados = bp.ID_PD
where cp.num_proc = @num_Proc and cp.id_campo = 143


--1	CHB
--2	Freight Forward
--3	CHB + Freight Forward
GO
