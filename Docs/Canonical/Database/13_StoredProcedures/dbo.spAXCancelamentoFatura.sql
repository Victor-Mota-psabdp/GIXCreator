SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAXCancelamentoFatura]

AS

--Procedimento criado para sinalizar para o AX as faturas que foram canceladas no ATL


Update Ax_Doc set dt_canc=fat.dt_canc from  ax_Doc AX
Join fatura fat on fat.fatcod=invoice_number
Where month(fat.dt_Canc) =month(getdate()-1) and year(fat.dt_canc)=year(getdate()-1) and AX.dt_Canc is null

GO
