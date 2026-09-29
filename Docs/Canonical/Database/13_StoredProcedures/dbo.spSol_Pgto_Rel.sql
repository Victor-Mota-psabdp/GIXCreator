SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--8028048 - sem job
--8028047 - com job
CREATE PROCEDURE [dbo].[spSol_Pgto_Rel] --8085289
		@ID bigint 
AS
-- House House Importação Aerea 
	select 
		SI.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],		
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HIA.MAWB_HIA [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],		
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco
	from	
		Sol_Pgto_Cta_Cte SOL			with(nolock) 
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Imp_Aer HIA			with(nolock) on hia.Num_Proc_HIA = SI.Num_Proc
	where
		SOL.ID = @ID

Union all
-- House Importação Marinha
		select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HIM.MAWB_HIM [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Imp_Mar HIM			with(nolock) on him.num_proc_him= SI.num_proc
	where
		SOL.ID = @ID
		
Union all
-- House Importaçõa Rodoviaria
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HIO.MAWB_HIO [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Imp_Out HIO			with(nolock) on hio.Num_Proc_HIO = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- House Exportação Aerea
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HEA.MAWB_HEA [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Exp_Aer HEA			with(nolock) on hea.Num_Proc_HEA = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- House Exportação Maritima
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HEM.MAWB_HEM [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Exp_Mar HEM			with(nolock) on hem.Num_Proc_HEM = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- House Exportação Rodoviaria
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HEO.MAWB_HEO [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock)on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_Exp_Out HEO			with(nolock) on heo.Num_Proc_HEO = SI.Num_Proc
	where
		SOL.ID = @ID
				
	
Union all
-- Master Importação Aerea
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],		
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],	
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		MIA.MAWB_MIA [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Master_Imp_Aer MIA			with(nolock) on mia.num_proc_mia = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- Master Importação Maritima
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		MIM.MAWB_MIM [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock)on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Master_Imp_Mar MIM			with(nolock) on mim.Num_Proc_MIM = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- Master Exportação Aerea
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		MEA.MAWB_MEA [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Master_Exp_Aer MEA			with(nolock) on mea.Num_Proc_MEA = SI.Num_Proc
	where
		SOL.ID = @ID
				
Union all
-- Master Exportação Maritima 
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		MEM.MAWB_MEM [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 
	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Master_Exp_Mar MEM			with(nolock) on mem.Num_Proc_MEM = SI.Num_Proc
	where
		SOL.ID = @ID
		
		
Union all
-- BDP Others
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		'' [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock) on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join House_BDP_OUT HIO			with(nolock) on hio.Num_Proc_HBO = SI.Num_Proc
		left join JOB_HBO JOB			with(nolock) on JOB.Num_Proc_HBO = SI.Num_Proc
	where
		SOL.ID = @ID
		and JOB.Num_Proc is null
		
	
Union all
-- BDP Others
	select 
		SOL.ID [Reference Number],
		Apelido [Cred/Deb],
		SOL.Dt_Vcto [Due Date],
		Solicitante.Nome_Usuario [User Register],
		(Case when SOL.Status_Aprovacao is null then 'Created'
			else 
				(Case when SOL.Status = 1 and SOL.Status_Aprovacao ='A' then 'Approved'
					Else
						(Case when SOL.Status_Aprovacao ='D' then 'Rejected'
							Else
								(Case when SOL.Status_Aprovacao ='E' then 'Rejected'
									Else
										(Case when SOL.Status = 0 then 'Canceled' end)end)end)end)end) [Approbal],
		TD.Nome_Tp_Doc [Payment Method],
		SOL.Vlr_Doc [Doc Value],
		SI.Num_Proc [JOB],
		TT.Nome_Tp_Tx [Name Rate],
		HIO.MAWB [MAWB],
		SI.DC [D/C],
		--SI.Vlr_Ref [Value],
		dbo.valor(SI.Vlr_Ref,SI.DC) [Value],
		SI.Cd_Tp_Moeda [Currency],
		SI.Par_Moeda [Ex. Rate],
		--SI.Vlr_Pgto_Rcto [Total Value],
		dbo.valor(SI.Vlr_Pgto_Rcto,SI.DC)[Total Value],
		SI.Num_Proc,
		SOL.InfBanco

	from 	
		Sol_Pgto_Cta_Cte SOL			with(nolock)
		join Usuario Solicitante		with(nolock) on SOL.Cd_Solicitante = Solicitante.Cd_Usuario
		join Tipo_Documento TD			with(nolock) on SOL.Cd_Tp_Doc = TD.Cd_Tp_Doc
		join Pessoa PS					with(nolock)  on SOL.Cd_Cred_Dev = Ps.cd_pes
		join Sol_Pgto_Cta_Cte_Item SI	with(nolock) on SOL.ID = SI.ID
		join Tipo_Taxa TT				with(nolock) on SI.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join JOB_HBO JOB				with(nolock) on JOB.Num_Proc_HBO = SI.Num_Proc
		join vwCliente_Alerta HIO		with(nolock) on hio.num_proc = JOB.Num_Proc
	where
		SOL.ID = @ID
		

GO
