SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spATLBuscaTpControleData_Sel
	@Num_Controle	Varchar(10)
AS


select  ID_Tipo_Data ID,Descricao_Tp_Data Descricao, '' Data from Tipo_data_Controle_fatura where Ativo='S'
GO
