SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE [dbo].[pAekContAtuValCon_Sel] 

AS
	Update Cta_Cte_Hou_Imp_Mar Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Hou_Imp_Aer Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Hou_Imp_Out Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Hou_Exp_Mar Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Hou_Exp_Aer Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Hou_Exp_Out Set Val_Con_Comp = Vlr_Contab_Ant  

	Update Cta_Cte_Mas_Imp_Mar Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Mas_Imp_Aer Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Mas_Exp_Mar Set Val_Con_Comp = Vlr_Contab_Ant  
	Update Cta_Cte_Mas_Exp_Aer Set Val_Con_Comp = Vlr_Contab_Ant

GO
