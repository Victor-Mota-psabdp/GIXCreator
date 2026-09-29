SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spEMIX_ZIP_BuscaJOB_Sel]--'1503785345','di'
	@DI as varchar(10),
	@tipo as varchar(2)
AS
	
if @tipo = 'DI' 
	select HIM.Num_Proc_HIM [Num_Proc],'005' ID_DC,I.ID,I.ID_Item , Campo from PO_HIM HIM with(nolock) 	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIM.num_proc_him
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIM.Numero_PO_HIM,'-',''),'/','') = @DI		
		)
		and HIM.ID_DC =5
		and E.Tipo_Consulta = 8
		and Campo = 'ZIP-DI'
	union all
	
		select HIA.Num_Proc_HIA  [Num_Proc],'005' ID_DC,I.ID,I.ID_Item, Campo from PO_HIA HIA  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIA.Num_Proc_HIA
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIA.Numero_PO_HIA,'-',''),'/','') = @DI		
		)
		and HIA.ID_DC =5
		and E.Tipo_Consulta = 8
		and Campo = 'ZIP-DI'
		
	UNION ALL
	
	select HIO.Num_Proc_HIO [Num_Proc],'005' ID_DC,I.ID,I.ID_Item , Campo from PO_HIO HIO 	 with(nolock)
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIO.Num_Proc_HIO
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIO.Numero_PO_HIO,'-',''),'/','') = @DI		
		)
		and HIO.ID_DC =5
		and E.Tipo_Consulta = 8
		and Campo = 'ZIP-DI'
		
else if @tipo = 'CI'
	select HIM.Num_Proc_HIM [Num_Proc],'006' ID_DC,I.ID,I.ID_Item , Campo from PO_HIM HIM  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIM.num_proc_him 
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIM.Numero_PO_HIM,'-',''),'/','') = @DI		
		)
		and HIM.ID_DC =5
		and E.Tipo_Consulta = 9	
		and Campo = 'ZIP-CI'
	union all
		select HIA.Num_Proc_HIA [Num_Proc],'006' ID_DC,I.ID,I.ID_Item , Campo from PO_HIA HIA  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIA.Num_Proc_HIA 
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIA.Numero_PO_HIA,'-',''),'/','') = @DI		
		)
		and HIA.ID_DC =5
		and E.Tipo_Consulta = 9	
		and Campo = 'ZIP-CI'
	union all
		select HIO.Num_Proc_HIO [Num_Proc],'006' ID_DC,I.ID,I.ID_Item , Campo from PO_HIO HIO  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = HIO.Num_Proc_HIO 
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(HIO.Numero_PO_HIO,'-',''),'/','') = @DI		
		)
		and HIO.ID_DC =5
		and E.Tipo_Consulta = 9	
		and Campo = 'ZIP-CI'
OPTION(HASH JOIN)
if @tipo = 'LI'
	select SOL.Num_Solicitacao [Num_Proc],'023' ID_DC,I.ID,I.ID_Item , Campo from Solicitacao_LI SOL  with(nolock)	
		join ATL_INT.dbo.Emix_Retorno E with(nolock) on E.Num_Proc = SOL.num_proc
		join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	where
		(
		replace(replace(SOL.Num_LI,'-',''),'/','') = @DI		
		)
		--and HIM.ID_DC =23
		and E.Tipo_Consulta = 12	
		and Campo = 'ZIP-LI'
OPTION(HASH JOIN)

	--select HIM.Num_Proc_HIM [Num_Proc],'023' ID_DC,I.ID,I.ID_Item , Campo from PO_HIM HIM 	
	--	join Emix_Retorno E on E.Num_Proc = HIM.num_proc_him
	--	join Emix_Retorno_Item I on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HIM.Numero_PO_HIM,'-',''),'/','') = @DI		
	--	)
	--	and HIM.ID_DC =23
	--	and E.Tipo_Consulta = 12	
	--	and Campo = 'ZIP-LI'
	--union all
	--	select HIA.Num_Proc_HIA  [Num_Proc],'023' ID_DC,I.ID,I.ID_Item, Campo from PO_HIA HIA 	
	--	join Emix_Retorno E on E.Num_Proc = HIA.Num_Proc_HIA
	--	join Emix_Retorno_Item I on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HIA.Numero_PO_HIA,'-',''),'/','') = @DI		
	--	)
	--	and HIA.ID_DC =23
	--	and E.Tipo_Consulta = 12	
	--	and Campo = 'ZIP-LI'
	--union all
	--	select HIO.Num_Proc_HIO  [Num_Proc],'023' ID_DC,I.ID,I.ID_Item, Campo from PO_HIO HIO	
	--	join Emix_Retorno E on E.Num_Proc = HIO.Num_Proc_HIO
	--	join Emix_Retorno_Item I on I.ID = E.ID 
	--where
	--	(
	--	replace(replace(HIO.Numero_PO_HIO,'-',''),'/','') = @DI		
	--	)
	--	and HIO.ID_DC =23
	--	and E.Tipo_Consulta = 12	
	--	and Campo = 'ZIP-LI'



		
--select * from Emix_Retorno_item  where  ID_item = '1' and Campo = 'ZIP-CI'

--select * from Emix_Retorno_item  where  ID_item = '1' and Campo = 'ZIP-CI'
--select * from Emix_Retorno where ID in (211,212)

--IMCSR201503321BR
--IMCSR201501200BR

--select * from PO_HIM where Num_Proc_HIM = 'IMCSR201503321BR' and ID_DC = 5
--select * from PO_HIM where Num_Proc_HIM = 'IMCSR201501200BR'  and ID_DC = 5

--spEMIX_ZIP_BuscaJOB_Sel '1505847518', 'CI'
		


















GO
