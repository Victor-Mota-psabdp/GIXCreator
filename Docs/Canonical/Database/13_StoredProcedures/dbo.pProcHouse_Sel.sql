SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pProcHouse_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pProcHouse_Sel 
(
@Orderby		Char(1) = ''
)
AS
	If @Orderby = 'H'
		Begin 
			Select	Num_Proc_MIM as ProcMaster, Num_Proc_HIM as ProcHouse, HAWB_HIM as House From House_Imp_Mar Where HAWB_HIM Is Not Null 
			Union
			Select 	Num_Proc_MEM as ProcMaster, Num_Proc_HEM as ProcHouse, HAWB_HEM as House  From House_Exp_Mar Where HAWB_HEM Is Not Null 
			Union
			Select 	Num_Proc_MIA as ProcMaster, Num_Proc_HIA as ProcHouse, HAWB_HIA as House  From House_Imp_Aer Where HAWB_HIA Is Not Null 
			Union 
			Select 	Num_Proc_MEA as ProcMaster, Num_Proc_HEA as ProcHouse, HAWB_HEA as House  From House_Exp_Aer Where HAWB_HEA Is Not Null 
			Order by House
		End 
	Else
		Begin 
			Select 	Num_Proc_MIM as ProcMaster, Num_Proc_HIM as ProcHouse, HAWB_HIM as House  From House_Imp_Mar 
			Union
			Select 	Num_Proc_MEM as ProcMaster, Num_Proc_HEM as ProcHouse, HAWB_HEM as House  From House_Exp_Mar 
			Union
			Select 	Num_Proc_MIA as ProcMaster, Num_Proc_HIA as ProcHouse, HAWB_HIA as House From House_Imp_Aer  
			Union 
			Select 	Num_Proc_MEA as ProcMaster, Num_Proc_HEA as ProcHouse, HAWB_HEA as House From House_Exp_Aer  
			Order by ProcHouse
		End



GO
