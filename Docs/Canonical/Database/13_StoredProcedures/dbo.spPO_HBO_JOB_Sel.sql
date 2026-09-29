SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPO_HBO_JOB_Sel]-- 'EACSR201510021BR'
	
	@Num_Proc		VarChar(16)	
	

AS	
		select 
			@Num_Proc,GETDATE(),19

	Union
	
		select
			EA.Numero_PO_HEA,EA.Data_PO_HEA,EA.ID_DC		
		from 
			PO_HEA EA
		where 
			EA.Num_Proc_HEA=@Num_Proc
		
	UNION		
		select
			IA.Numero_PO_HIA,IA.Data_PO_HIA,IA.ID_DC	
		from 
			PO_HIA IA		
		where
			IA.Num_Proc_HIA=@Num_Proc
			
	UNION
		
		select
			EM.Numero_PO_HEM,EM.Data_PO_HEM,EM.ID_DC	
		from 
			PO_HEM EM		
		where
			EM.Num_Proc_HEM=@Num_Proc
			
	UNION
		
		select
			IM.Numero_PO_HIM,IM.Data_PO_HIM,IM.ID_DC		
		from 
			PO_HIM IM		
		where
			IM.Num_Proc_HIM=@Num_Proc	
			
	UNION
			
		select
			EO.Numero_PO_HEO,EO.Data_PO_HEO,EO.ID_DC	
		from 
			PO_HEO EO		
		where
			EO.Num_Proc_HEO=@Num_Proc
			
	UNION
		
		select
			PIO.Numero_PO_HIO,PIO.Data_PO_HIO,PIO.ID_DC	
		from 
			PO_HIO PIO		
		where
			PIO.Num_Proc_HIO=@Num_Proc
order by 3
GO
