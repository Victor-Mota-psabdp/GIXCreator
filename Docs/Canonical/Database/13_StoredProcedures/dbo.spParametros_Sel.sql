SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Report_parametro
--[spParametros_Sel] 'spDemurrageTaxas_InsUpd'

CREATE procedure [dbo].[spParametros_Sel] 
	@id_report int,
	@sp varchar(50)
as
    SELECT
		@id_report ID,
		SCOL.colorder Ordem,
		NULL Descr,
		SCOL.name Nome_Parametro,
		(case 
			when STY.name = 'int' then 'I'
			when STY.name = 'decimal' then 'F'
			when STY.name = 'float' then 'F'
			when STY.name = 'datetime' then 'D'
			else 'S'
		end) Tipo
    FROM 
		sysobjects SOBJ
		JOIN syscolumns SCOL ON SCOL.Id = SOBJ.Id
	    JOIN systypes STU ON STU.xusertype = SCOL.xusertype
		JOIN systypes STY ON STY.xusertype = SCOL.xtype
	WHERE
		SOBJ.NAME = @sp
    ORDER BY 
		SCOL.colorder







GO
