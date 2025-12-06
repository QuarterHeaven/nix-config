final: prev: {
  boost177 = prev.boost177.overrideAttrs (old: {
    # 移除 sanitiseHeaderPathsHook
    nativeBuildInputs = builtins.filter 
      (dep: 
        let name = dep.pname or (dep.name or "");
        in name != "sanitise-header-paths-hook"
      )
      (old.nativeBuildInputs or []);
    
    # 不要修改 src，保持原样
    # src = old.src;  # 这是隐含的，不需要写
    
    # 移除 preFixup
    preFixup = "";
    
    # 修改 postFixup
    postFixup = ''
      # 使头文件路径相对化
      cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
        -exec sed '1s/^\xef\xbb\xbf//;1i#line 1 "{}"' -i '{}' \; || true
    '' + (old.postFixup or "");
  });
  
  # 同样处理 boost182
  boost182 = prev.boost182.overrideAttrs (old: {
    nativeBuildInputs = builtins.filter 
      (dep: 
        let name = dep.pname or (dep.name or "");
        in name != "sanitise-header-paths-hook"
      )
      (old.nativeBuildInputs or []);
    
    preFixup = "";
    
    postFixup = ''
      cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
        -exec sed '1s/^\xef\xbb\xbf//;1i#line 1 "{}"' -i '{}' \; || true
    '' + (old.postFixup or "");
  });
}
