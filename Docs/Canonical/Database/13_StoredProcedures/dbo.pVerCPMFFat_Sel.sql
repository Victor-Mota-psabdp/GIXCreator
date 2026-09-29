SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pVerCPMFFat_Sel 
(
@num_proc 		VarChar(16),
@Fat_old		varchar(17)  = ''
)
AS
	select 
		isnull(sum(VLR_Rs),0) Total  from fatura fat 
		join item_fat itf  on itf.fatcod = fat.fatcod 
	where 
		fatstatus = 1 and 
		cd_tp_tx like 'C$%' and 
		itf.num_proc = @num_proc and 
		fat.fatcod <> @Fat_Old
GO
