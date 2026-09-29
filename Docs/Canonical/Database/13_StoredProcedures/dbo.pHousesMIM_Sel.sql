SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pHousesMIM_Sel  
(
@Num_Proc	varchar(14)
)
AS
	Select Num_Proc_HIM From House_Imp_Mar where Num_Proc_MIM = @Num_Proc
GO
