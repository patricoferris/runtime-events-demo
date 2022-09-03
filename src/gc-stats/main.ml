open Runtime_events

(* $MDX part-begin=1 *)

let runtime_counter (major, minor_prom, minor_alloc) _domain_id _ts counter
    value =
  match counter with
  | EV_C_REQUEST_MAJOR_ALLOC_SHR ->
      major := !major + value;
      Util.print_stats ~major ~minor_prom ~minor_alloc
  | EV_C_MINOR_PROMOTED ->
      minor_prom := !minor_prom + value;
      Util.print_stats ~major ~minor_prom ~minor_alloc
  | EV_C_MINOR_ALLOCATED ->
      minor_alloc := !minor_alloc + value;
      Util.print_stats ~major ~minor_prom ~minor_alloc
  | _ -> ()

(* $MDX part-end *)

(* $MDX part-begin=2 *)
let tracing child_alive path_pid =
  let major, minor_alloc, minor_prom = (ref 0, ref 0, ref 0) in
  let c = create_cursor path_pid in
  let runtime_counter = runtime_counter (major, minor_alloc, minor_prom) in
  let cbs = Callbacks.create ~runtime_counter () in
  (* $MDX part-end *)
  (* $MDX part-begin=poll *)
  while child_alive () do
    ignore (read_poll c cbs None);
    Unix.sleepf 0.1
  done
(* $MDX part-end *)

(* $MDX part-begin=main *)
let () =
  (* Extract the user supplied program and arguments. *)
  let prog, args = Util.prog_args_from_sys_argv Sys.argv in
  let proc =
    Unix.create_process_env prog args
      [| "OCAML_RUNTIME_EVENTS_START=1" |]
      Unix.stdin Util.dev_null_out Util.dev_null_out
  in
  Unix.sleepf 0.1;
  tracing (Util.child_alive proc) (Some (".", proc));
  Printf.printf "\n"
(* $MDX part-end *)
